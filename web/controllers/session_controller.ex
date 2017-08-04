defmodule ParpServer.SessionController do
  use ParpServer.Web, :controller

  alias ParpServer.Session
  alias ParpServer.User

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

  def sessionCheck(conn, %{"username" => username , "token" => token}) do
    myuser = Session.checkSession(%{username: username , token: token})
    if !myuser do
      json(conn, %{"error": "session not vaild"})
    else
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
end
