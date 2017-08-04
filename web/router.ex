defmodule ParpServer.Router do
  use ParpServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ParpServer.Plug.SessionPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :uapi do
    plug :accepts, ["json"]
  end

  scope "/", ParpServer do
    pipe_through :browser # Use the default browser stack

    #get "/", PageController, :index
    get "/", AvatarController, :indexhtml
    get "/avatar/:id", AvatarController, :avatar1html
    get "/login", PageController, :loginhtml
    get "/car", CarController, :indexhtml
  end

  # Other scopes may use custom stacks.
  scope "/api", ParpServer do
    pipe_through :api
    resources "/avatars", AvatarController
    post "/avatar_leave_parking", AvatarController, :avatar_leave_parking
    resources "/at_hisotry", AtHistoryController
    get "/avatar_get_at/:id", AtHistoryController, :showbyAvatar
    post "/avatar_no_found_update_all", AtHistoryController, :no_avatar
    resources "/v1/user", UserController
    post "/v1/login", UserController, :login
    get "/v1/login", PageController, :login
    #for test
    # post "/v1/uploadimg", PageController, :uploadImg
    post "/v1/uploadimg", PageController, :uploadImgOnly

    resources "/v1/car", CarController
    get "/v1/get_car_list", AvatarController, :getParkingPlaceByStatus
  end

  scope "/api", ParpServer do
    pipe_through :uapi
    resources "/v1/session", SessionController, only: [:delete]
    post "/v1/current_user", SessionController, :sessionCheck
  end

end
