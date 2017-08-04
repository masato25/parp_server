defmodule ParpServer.UserController do
  use ParpServer.Web, :controller
  alias ParpServer.Session
  alias ParpServer.User

  def index(conn, _params) do
    user = Repo.all(User)
    render(conn, "index.json", user: user)
  end

  def login(conn, %{"username" => username, "password" => password}) do
    endcodeingPass = User.encoding(password)
    nuser = Repo.all( from user in User,
              where: user.username == ^username and user.password == ^endcodeingPass,
              limit: 1,
              preload: [:sessions]
            )
    if nuser == [] do
      json(conn, %{"error": "user not found or password is incorrent"})
    else
      nuser = nuser |> hd
      sessions = nuser.sessions
      if sessions == [] do
        case Session.changeset(%Session{}, %{user_id: nuser.id}) |> Repo.insert() do
          {:ok, session} ->
            conn
            |> json(%{username: username, "token": Map.get(session, :session_key)})
          {:error, changeset} ->
            conn
            |> json(%{"error": "can not create session", "error_message": inspect(changeset)})
        end
      else
        session = sessions |> hd
        json(conn, %{"username": username, "token": Map.get(session, :session_key)})
      end
    end
  end



  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, session} = Session.changeset(%Session{}, %{user_id: user.id}) |> Repo.insert()
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("showwithsession.json", %{user: user, session: session})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
