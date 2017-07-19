defmodule ParpServer.AvatarController do
  use ParpServer.Web, :controller
  alias ParpServer.Avatar
  alias ParpServer.AtHistory
  alias ParpServer.Helper.TimeUtils
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
    id = findAvatar(avatar_params)
    if id != -1 do
      params = %{"id" => id, "avatar" => avatar_params}
      ParpServer.AvatarController.update(conn, params)
    else
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
    end
  end

  def show(conn, %{"id" => id}) do
    avatar = Repo.get!(Avatar, id)
    render(conn, "show.json", avatar: avatar)
  end

  def update(conn, %{"id" => id, "avatar" => avatar_params}) do
    avatar = Repo.get!(Avatar, id)
    avatar_params = Map.put(avatar_params, "updated_at", DateTime.to_unix(Timex.now))
    avatar_params = Map.put(avatar_params, "parking_status", "parking")
    changeset = Avatar.changeset(avatar, avatar_params)
    at_history = Avatar.findLastAtHistory(avatar)
    if is_nil(at_history) do
      Avatar.createAtHistory(avatar)
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
end
