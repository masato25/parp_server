defmodule ParpServer.SessionController do
  use ParpServer.Web, :controller
  alias ParpServer.Helper.ApiHelp
  alias ParpServer.Session
  alias ParpServer.User
  alias ParpServer.Avatar
  alias ParpServer.AtHistory
  require Logger
  use PhoenixSwagger

  def index(conn, _params) do
    session = Repo.all(Session)
    render(conn, "index.json", session: session)
  end

  def create(conn, %{"session" => session_params}) do
    changeset = Session.changeset(%Session{}, session_params)

    case Repo.insert(changeset) do
      {:ok, session} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", session_path(conn, :show, session))
        |> render("show.json", session: session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    session = Repo.get!(Session, id)
    render(conn, "show.json", session: session)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Repo.get!(Session, id)
    changeset = Session.changeset(session, session_params)

    case Repo.update(changeset) do
      {:ok, session} ->
        render(conn, "show.json", session: session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    session = Repo.get!(Session, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(session)

    send_resp(conn, :no_content, "")
  end

  def sessionCheck(conn, _params) do
    session = ApiHelp.getSessionFromHeader(conn)
    if session == - 1 do
      json(conn, %{"error": "session not vaild"})
    else
      myuser = Session.checkSession(session)
      userjson = %{
        id: myuser.id,
        username: myuser.username,
        name: myuser.name,
        gender: myuser.gender,
        birthday: myuser.birthday,
        parking_license: myuser.parking_license,
        payment: myuser.payment
      }
      json(conn, %{user: userjson})
    end
  end

  def user_self_set_parking(conn, %{"custom_name" => custom_name}) do
    session = ApiHelp.getSessionFromHeader(conn)
    if session == - 1 do
      json(conn, %{"error": "session not vaild"})
    else
      Logger.info(inspect session)
      myuser = Session.checkSession(session)
      Logger.info(inspect myuser)
      avatar = Repo.all(from ava in Avatar,
                        where: ava.custom_name == ^custom_name)
      if avatar == [] do
        json(conn, %{error: "no found custom_name: #{custom_name}"})
      else
        avatar = hd(avatar)
        at_history = Avatar.findLastAtHistory(avatar)
        if is_nil(at_history) do
          json(conn, %{error: "no any parking info of #{custom_name}"})
        else
          uid = Map.get(myuser, :id)
          changeset = AtHistory.changeset(at_history,
            %{user_id: uid})
          case Repo.update(changeset) do
            {:ok, changeset} ->
              json(conn, %{msg: "ok"})
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
              json(conn, %{error: Map.get(changeset, :errors)})
          end
        end
      end
    end
  end

  # swagger #
  swagger_path :sessionCheck do
    get "/v1/current_user"
    produces "application/json"
    description "Get current user info && authorize session"
    parameters do
      authorization :header, :string, "parpuser1 NegZIJa8Q3QP57-g", required: true
    end
    response(200, """
      {
        "data": {
          "username": "parpuser1",
          "payment": null,
          "parking_license": "AP-0012",
          "name": "司馬亭",
          "id": 5,
          "gender": "female",
          "birthday": "1985-07-22"
        }
      }
    """)
  end
end
