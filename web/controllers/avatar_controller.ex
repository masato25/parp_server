defmodule ParpServer.AvatarController do
  use ParpServer.Web, :controller
  alias ParpServer.Helper.ApiHelp
  alias ParpServer.Avatar
  alias ParpServer.Session
  alias ParpServer.AtHistory
  alias ParpServer.Helper.TimeUtils
  use PhoenixSwagger
  import Logger

  def indexhtml(conn, _params) do
    avatar = Repo.all(Avatar)
    conn |>
    put_layout("page.html") |>
    render("page.html", avatar: avatar)
  end

  def avatar1html(conn, %{"id" => id}) do
    conn |>
    put_layout("avatar1.html") |>
    render("page.html", [])
  end


  def index(conn, _params) do
    avatar = Repo.all(Avatar)
    render(conn, "index.json", avatar: avatar)
  end

  defp findAvatar(avatar_params) do
    avatar = Repo.all(
      from ava in Avatar,
      where: ava.address == ^Map.get(avatar_params, "address")
    )

    cond do
      avatar != [] ->
        Map.get(hd(avatar), :id)
      true ->
        -1
    end
  end

  def create(conn, %{"avatar" => avatar_params}) do
    avatar_params = Map.put(avatar_params, "latest_report", TimeUtils.naiveTimeNow)
    # check avatar is existing?
    # id = findAvatar(avatar_params)
    # if id != -1 do
      # params = %{"id" => id, "avatar" => avatar_params}
      # ParpServer.AvatarController.update(conn, params)
    # else
      changeset = Avatar.changeset(%Avatar{}, avatar_params)
      case Repo.insert(changeset) do
        {:ok, avatar} ->
          Avatar.createAtHistory(avatar)
          conn
          |> put_status(:created)
          |> put_resp_header("location", avatar_path(conn, :show, avatar))
          |> render("show.json", avatar: avatar)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
      end
    # end
  end

  def show(conn, %{"id" => id}) do
    avatar = Repo.get!(Avatar, id)
    render(conn, "show.json", avatar: avatar)
  end

  def update(conn, %{"id" => id, "avatar" => avatar_params}) do
    avatar = Repo.get!(Avatar, id)
    # avatar_params = Map.put(avatar_params, "updated_at", DateTime.to_unix(Timex.now))
    # avatar_params = Map.put(avatar_params, "parking_status", "parking")
    changeset = Avatar.changeset(avatar, avatar_params)
    if Map.get(avatar_params, "parking_status") == "paring" do
      at_history = Avatar.findLastAtHistory(avatar)
      if is_nil(at_history) do
        Avatar.createAtHistory(avatar)
      end
    end
    case Repo.update(changeset) do
      {:ok, avatar} ->
        render(conn, "show.json", avatar: avatar)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    avatar = Repo.get!(Avatar, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(avatar)

    send_resp(conn, :no_content, "")
  end

  def avatar_leave_parking(conn, %{"address" => address}) do
    avatar = Repo.all(from ava in Avatar,
                      where: ava.address == ^address)
    if avatar == [] do
      json(conn, %{error: "no found address: #{address}"})
    else
      avatar = hd(avatar)
      at_history = Avatar.findLastAtHistory(avatar)
      if is_nil(at_history) do
        json(conn, %{error: "no any parking info of #{avatar}"})
      else
        changeset = AtHistory.changeset(at_history, %{"status": "leave", "end_at": TimeUtils.naiveTimeNow, "parking_status": "available"})
        case Repo.update(changeset) do
          {:ok, changeset} ->
            changeset = Avatar.changeset(avatar, %{"update_at": DateTime.to_unix(Timex.now),"parking_status": "available"})
            Repo.update(changeset)
            json(conn, %{msg: "ok"})
          {:error, changeset} ->
            Logger.error("[avatar_leave_pakring] update at_history got error: #{IO.inspect Map.get(changeset, :errors)}")
            json(conn, %{error: Map.get(changeset, :errors)})
        end
      end
    end
  end

  def getParkingPlaceByStatus(conn, %{"status" => status}) do
    avatars = []
    flag = true
    case status do
      "parking" ->
        avatars = Repo.all( from c in Avatar,
          where: c.parking_status == "parking"
        )
      "available" ->
        avatars = Repo.all( from c in Avatar,
          where: c.parking_status == "available"
        )
      "can_resv" ->
        avatars = Repo.all( from c in Avatar,
          where: c.parking_status == "available" and is_nil(c.user_id)
        )
      "all" ->
        avatars = Repo.all(Avatar)
      _ ->
        flag = false
        json(conn, %{"error": "status type is wrong"})
    end

    if flag do
      render(conn, "index.json", avatar: avatars)
    end
  end

  def getParkingPlaceByStatus(conn, _params) do
    avatars = Repo.all(Avatar)
    render(conn, "index.json", avatar: avatars)
  end

  def reservationParking(conn, %{"parking_id" => parking_id, "rs" => rs}) do
    session = ApiHelp.getSessionFromHeader(conn)
    if session == - 1 do
      json(conn, %{"error": "session not vaild"})
    else
      myuser = Session.checkSession(session)
      if !myuser do
        json(conn, %{"error": "session not vaild"})
      else
        avatar = Repo.all(from at in Avatar,
          where: at.id == ^parking_id,
          limit: 1)
        cond do
          avatar == [] ->
            json(conn, %{"error": "parking id not found"})
          is_nil(Map.get(hd(avatar), :user_id, nil)) && rs == true->
            json(conn, %{"error": "parking id not available"})
          rs == "false" ->
            avatar = avatar |> hd
            changeset = Avatar.changeset(avatar, %{user_id: nil, reservation_at: nil})
            case Repo.update(changeset) do
              {:ok, avatar} ->
                render(conn, "show.json", avatar: avatar)
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
            end
          true ->
            avatar = avatar |> hd
            uid = Map.get(myuser, :id)
            timeNow = DateTime.utc_now |> DateTime.to_naive
            changeset = Avatar.changeset(avatar, %{user_id: uid, reservation_at: timeNow})
            case Repo.update(changeset) do
              {:ok, avatar} ->
                render(conn, "show.json", avatar: avatar)
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
            end
        end
      end
    end
  end

  # swagger #
  swagger_path :getParkingPlaceByStatus do
    get "/v1/get_car_list"
    produces "application/json"
    description "Get parking with status filter, 支援狀態 [praking, available, can_resv, all]  -> (ps. can_resv 表示該車位沒人停可以預約)"
    parameters do
      status :query, :string, "parking", required: false
    end
    response(200, """
      {
        "data": [
          {
            "price_set": " / 3600 * 20",
            "parking_status": "available",
            "name": "Drive+",
            "latest_report": "2017-07-18 09:02:11",
            "inserted_at": "2017-07-18 09:02:11",
            "id": 22,
            "custom_name": null,
            "coordinate": "25.0405821,121.5686972",
            "bluetooth_type": 1,
            "bluetooth_status": 10,
            "address": "10:C6:FC:EE:DE:9C"
          },
          {
            "price_set": " / 3600 * 20",
            "parking_status": "available",
            "name": "S8np0750",
            "latest_report": "2017-07-18 09:21:06",
            "inserted_at": "2017-07-18 09:21:06",
            "id": 39,
            "custom_name": null,
            "coordinate": "25.0379561,121.5687641",
            "bluetooth_type": 1,
            "bluetooth_status": 10,
            "address": "6C:5C:14:56:69:39"
          },
          {
            "price_set": " / 3600 * 20",
            "parking_status": "available",
            "name": "bike:D193D7F05N400",
            "latest_report": "2017-07-18 09:11:31",
            "inserted_at": "2017-07-18 09:10:36",
            "id": 27,
            "custom_name": null,
            "coordinate": "25.0405821,121.5686972",
            "bluetooth_type": 2,
            "bluetooth_status": 10,
            "address": "C8:FD:19:3D:7F:05"
          }
        ]
      }
    """)
  end

  # swagger #
  swagger_path :reservationParking do
    get "/api//v1/reservation_parking"
    produces "application/json"
    description "預約 or 取消預約停車資訊, rs 為 true 為預約 re 為 false 為取消預約"
    parameters do
      parking_id :query, :integer, "10", required: true
      rs :query, :boolean , "true", required: true
      authorization :header, :string, "parpuser1 NegZIJa8Q3QP57-g", required: true
    end
    response(200, """
      {
        "data": {
          "user_id": 8,
          "reservation_at": 1501921695,
          "price_set": " / 3600 * 20",
          "parking_status": "available",
          "name": "nuvi #3848828232",
          "latest_report": "2017-07-18 08:59:49",
          "inserted_at": "2017-07-18 08:59:49",
          "id": 10,
          "custom_name": null,
          "coordinate": "25.0405821,121.5686972",
          "bluetooth_type": 1,
          "bluetooth_status": 10,
          "address": "10:C6:FC:1E:8F:B7"
        }
      }
    """)
  end

end
