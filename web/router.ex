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

  scope "/", ParpServer do
    pipe_through :browser # Use the default browser stack

    #get "/", PageController, :index
    get "/", AvatarController, :indexhtml
    get "/avatar/:id", AvatarController, :avatar1html
    get "/login", PageController, :loginhtml
  end

  # Other scopes may use custom stacks.
  scope "/api", ParpServer do
    pipe_through :api
    resources "/avatars", AvatarController
    post "/avatar_leave_pakring", AvatarController, :avatar_leave_pakring
    resources "/at_hisotry", AtHistoryController
    get "/avatar_get_at/:id", AtHistoryController, :showbyAvatar
    post "/avatar_no_found_update_all", AtHistoryController, :no_avatar
    resources "/user", UserController

    get "/v1/login", PageController, :login
  end
end
