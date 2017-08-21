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
    get "/map_test", PageController, :map_test
  end

  # Other scopes may use custom stacks.
  scope "/api", ParpServer do
    pipe_through :api
    # for test
    get"/map_test", PageController, :maptest

    resources "/avatars", AvatarController
    post "/avatar_leave_parking", AvatarController, :avatar_leave_parking
    post "/avatar_start_parking", AvatarController, :set_parking_start
    resources "/at_hisotry", AtHistoryController
    get "/v1/pending_parking_check", AtHistoryController, :find_pending_check_parking
    get "/v1/update_parking_license_all", AtHistoryController, :update_parking_license_all
    put "/v1/set_parking_license", AtHistoryController, :set_parking_license
    get "/avatar_get_at/:id", AtHistoryController, :showbyAvatar
    post "/avatar_no_found_update_all", AtHistoryController, :no_avatar
    resources "/v1/user", UserController, except: [:update]
    put "/v1/user", UserController, :update
    put "/v1/chpasswd", UserController, :chpasswd
    post "/v1/login", UserController, :login
    get "/v1/login", PageController, :login
    #for test
    # post "/v1/uploadimg", PageController, :uploadImg
    post "/v1/uploadimg", PageController, :uploadImgOnly

    resources "/v1/car", CarController
    get "/v1/get_car_list", AvatarController, :getParkingPlaceByStatus
    get "/v1/testsocket", AvatarController, :helpResposeSocket
    post "/v1/user_report_parking", SessionController, :user_self_set_parking
    get "/v1/pay_parking_at/:id",  AtHistoryController, :paid_avatar
  end

  scope "/api", ParpServer do
    pipe_through :uapi
    resources "/v1/session", SessionController, only: [:delete]
    get "/v1/current_user", SessionController, :sessionCheck
    get "/v1/reservation_parking", AvatarController, :reservationParking
  end


  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :parp_server, swagger_file: "parp.json", disable_validator: true
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "PARP APP"
      }
    }
  end

end
