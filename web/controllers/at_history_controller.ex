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
end
