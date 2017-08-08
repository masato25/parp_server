defmodule ParpServer.UserController do
  use ParpServer.Web, :controller
  alias ParpServer.Helper.ApiHelp
  alias ParpServer.Session
  alias ParpServer.User
  require Logger
  use PhoenixSwagger

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
            |> put_status(:created)
            |> put_resp_header("location", user_path(conn, :show, nuser))
            |> render("showwithsession.json", %{user: nuser, session: session})
          {:error, changeset} ->
            conn
            |> json(%{"error": "can not create session", "error_message": inspect(changeset)})
        end
      else
        session = sessions |> hd
        conn
            |> put_status(:created)
            |> put_resp_header("location", user_path(conn, :show, nuser))
            |> render("showwithsession.json", %{user: nuser, session: session})
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

  def update(conn, %{"user" => user_params}) do
    session = ApiHelp.getSessionFromHeader(conn)
    if session == - 1 do
      json(conn, %{"error": "session not vaild"})
    else
      tuser = Session.checkSession(session)
      if !tuser do
         json(conn, %{"error": "session not vaild"})
      else
        changeset = User.changeset_update(tuser, user_params)
        case Repo.update(changeset) do
          {:ok, user} ->
            render(conn, "show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
        end
      end
    end
  end

  def chpasswd(conn, %{"new_password" => password, "old_password" => old_password}) do
    session = ApiHelp.getSessionFromHeader(conn)
    if session == - 1 do
      json(conn, %{"error": "session not vaild"})
    else
      tuser = Session.checkSession(session)
      if !tuser do
         json(conn, %{"error": "session not vaild"})
      else
        uname = Map.get(tuser, :username)
        optpass = User.encoding(old_password)
        nuser = Repo.all( from user in User,
                  where: user.username == ^uname and user.password == ^optpass,
                  limit: 1
                )
        if nuser == [] do
          json(conn, %{"error": "old password not match"})
        else
          nuser = nuser |> hd
          changeset = User.changeset(nuser, %{password: password})
          case Repo.update(changeset) do
            {:ok, _} ->
              json(conn, %{"message": "password updated"})
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
          end
        end
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  def swagger_definitions do
    %{
      User: JsonApi.resource do
        description "A user that may have one or more supporter pages."
        attributes do
          user Schema.ref(:UserBody), "user body", required: true
        end
      end,
      UserBody: JsonApi.resource do
        description ""
        attributes do
          name :string, "司馬亭", required: true
          gender :string, "male"
          birthday :string, "1985-07-22"
          parking_license :string, "AP-0012", required: true
          password :string, "p00123", required: true
          username :string, "parpuser1", required: true
          payment :string, "{cv: 000}"
        end
      end
    }
  end

  # swagger #
  swagger_path :create do
    post "/api/v1/user"
    produces "application/json"
    description "Create user, 這邊先簡單把支付資訊轉成json string直接寫進去payment"
    parameters do
      user :object, Schema.ref(:User), ""
    end
    response(200, """
      {
        "session": {
          "username": "parpuser1",
          "session": "NegZIJa8Q3QP57-g"
        },
        "data": {
          "username": "parpuser1",
          "payment": null,
          "parking_license": "AP-0012",
          "name": "司馬亭",
          "id": 5,
          "gender": "male",
          "birthday": "1985-07-22"
        }
      }
    """)
    response(304, """
      {
        "errors": {
          "username": [
            "has already been taken"
          ]
        }
      }
    """)
  end


  # swagger #
  swagger_path :login do
    post "/api/v1/login"
    produces "application/json"
    description "Login User"
    parameters do
      username :query, :string, "parpuser1", required: true
      password :query, :string, "p00123", required: true
    end
    response(200, """
      {
        "session": {
          "username": "parpuser1",
          "session": "NegZIJa8Q3QP57-g"
        },
        "data": {
          "username": "parpuser1",
          "payment": null,
          "parking_license": "AP-0012",
          "name": "司馬亭",
          "id": 5,
          "gender": "male",
          "birthday": "1985-07-22"
        }

    """)
  end

  # swagger #
  swagger_path :update do
    put "/api/v1/user"
    produces "application/json"
    description "Update User, authorization 為有效的session"
    parameters do
      name :query, :string, "司馬亭", required: true
      gender :query, :string, "female"
      birthday :query, :string, "1985-07-22"
      parking_license :query, :string, "AP-0012"
      payment :query, :string, "{cv: 000}"
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

  # swagger #
  swagger_path :chpasswd do
    put "/api/v1/chpasswd"
    produces "application/json"
    description "Update User's password, authorization 為有效的session"
    parameters do
      new_password :query, :string, "p00123"
      old_password :query, :string, "parpuser1"
      authorization :header, :string, "parpuser1 NegZIJa8Q3QP57-g", required: true
    end
    response(200, "{\"message\":\"password updated\"}")
  end

end
