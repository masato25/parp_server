defmodule ParpServer.AtHistoryController do
  use ParpServer.Web, :controller

  alias ParpServer.AtHistory
  alias ParpServer.Avatar
  alias ParpServer.Helper.TimeUtils
  import Logger

  def index(conn, _params) do
    at_history = Repo.all(AtHistory)
    render(conn, "index.json", at_history: at_history)
  end

  def create(conn, %{"at_history" => at_history_params}) do
    changeset = AtHistory.changeset(%AtHistory{}, at_history_params)

    case Repo.insert(changeset) do
      {:ok, at_history} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", at_history_path(conn, :show, at_history))
        |> render("show.json", at_history: at_history)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    at_history = Repo.get!(AtHistory, id)
    render(conn, "show.json", at_history: at_history)
  end

  def showbyAvatar(conn, %{"id" => avatar_id}) do
    at_history = Repo.all(
      from ath in AtHistory,
      where: ath.avatar_id == ^avatar_id,
      order_by: [desc: :start_at],
      limit: 100
    )
    render(conn, "index.json", at_history: at_history)
  end


  def update(conn, %{"id" => id, "at_history" => at_history_params}) do
    at_history = Repo.get!(AtHistory, id)
    changeset = AtHistory.changeset(at_history, at_history_params)

    case Repo.update(changeset) do
      {:ok, at_history} ->
        render(conn, "show.json", at_history: at_history)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    at_history = Repo.get!(AtHistory, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(at_history)

    send_resp(conn, :no_content, "")
  end

  def no_avatar(conn, _params) do
    at_historys = Repo.all(
      from ath in AtHistory,
      where: ath.status == "parking"
    )
    at_historys |> Enum.each(fn ath ->
      ath_tmp = AtHistory.changeset(ath, %{status: "leave", end_at: TimeUtils.naiveTimeNow})
      case Repo.update(ath_tmp) do
        {:error, changeset} ->
          Logger.info("update at_historys: #{IO.inspect Map.get(changeset, :errors)}")
        {:ok, _} ->
          # do nothing
      end
    end)
    json(conn, %{msg: "ok"})
  end

  def paid_avatar(conn, %{"id" => id}) do
    atHistory = Repo.get!(AtHistory, id)
    changeset = AtHistory.changeset(atHistory, %{paid_status: true})
    case Repo.update(changeset) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
      {:ok, _} ->
        json(conn, %{"message": "ok"})
    end
  end

  def find_pending_check_parking(conn, _params) do
    atHistory = Repo.all(from ah in AtHistory,
                  where: is_nil(ah.user_id) and is_nil(ah.parking_license) and (ah.status == 'parking')
                )
                # |> Enum.map(&Poison.encode!(&1))
                # |> Enum.map(&Poison.decode!(&1))
    if is_nil(atHistory) do
      json(conn, avatars: nil)
    else
      collectAvatar = atHistory |> Enum.map(fn o ->
        Map.get(o, :avatar_id)
      end) |> Enum.uniq |> List.flatten
      avatar = Repo.all(
        from at in Avatar,
        where: at.id in ^collectAvatar )
      |> Enum.map(&Poison.encode!(&1))
      |> Enum.map(&Poison.decode!(&1))

      atHistory = atHistory
        |> Enum.map(&Poison.encode!(&1))
        |> Enum.map(&Poison.decode!(&1))
        |> Enum.group_by(&Map.get(&1, :avatar_id))
      avatars = avatar |> Enum.map(fn aa ->
        avatar_id = Map.get(aa, "id")
        ats = Map.get(atHistory, avatar_id)
        aa = Map.put(aa, "at_historys", ats)
      end)
      json(conn, %{avatars: avatars})
    end
  end

  #for resolve old parking records
  def update_parking_license_all(conn, _params) do
    atHistory = Repo.all(from ah in AtHistory,
                  where: is_nil(ah.user_id) and is_nil(ah.parking_license)
                )
    atHistory |> Enum.each(fn ah ->
      changeset = AtHistory.changeset(ah, %{parking_license: "PARP-9999"})
      Repo.update(changeset)
    end)
    json(conn, %{"msg": "ok"})
  end

  def set_parking_license(conn, params) do
    case params do
      %{"parking_id" => parking_id, "parking_license" => parking_license} ->
        atHistory = Repo.get!(AtHistory, parking_id)
        if is_nil(atHistory) do
          render(conn, %{"error": "not found any parking history of parking_id: #{parking_id}"})
        else
          changeset = AtHistory.changeset(atHistory, %{parking_license: "PARP-9999"})
          Repo.update(changeset)
          json(conn, %{"msg": "ok"})
        end
      true ->
        json(conn, %{"error": "parking_id & parking_license is required field, please check"})
    end
  end

end
