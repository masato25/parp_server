defmodule ParpServer.PageController do
  use ParpServer.Web, :controller
  require Logger
  alias ParpServer.Avatar
  alias ParpServer.Car
  alias ParpServer.AtHistory

  def map_test(conn, _params) do
    conn |>
    put_layout("map.html") |>
    render("map_test.html")
  end

  def index(conn, _params) do
    render conn, "index.html"
  end

  def loginhtml(conn, _params) do
    conn
    |>  put_layout("login.html")
    |>  render("index.html")
  end

  def login(conn, params) do
    passwd = Map.get(params, "passwd")
    cond do
      is_nil(passwd) ->
        conn |>
        json(%{data:
              %{
                error: %{
                  message: "passwd is empty"
                }
              }
            })
      passwd == Application.get_env(:parp_server, :login_password) ->
        conn |>
        json(%{data: %{msg: "ok", extoken: Application.get_env(:parp_server, :token_key)}})
      true ->
        conn |>
        json(%{data:
                %{
                  error: %{
                    message: "passwd is wrong"
                  }
                }
              })
    end
  end

  def uploadImgOnly(conn, params) do
    img = Map.get(params, "img")
    openalpr_key = Application.get_env(:parp_server, :openalpr_key)
    {status, resp} = HTTPoison.post("https://api.openalpr.com/v2/recognize_bytes?secret_key=#{openalpr_key}&recognize_vehicle=0&country=us&return_image=0&topn=10", img, [{"Content-Type", "application/json"}])
    case status do
      :ok ->
        Logger.info(":ok")
        c = Poison.decode!(resp.body)
        results = c["results"]
        if results != [] do
          Logger.info("reuslt != []")
          plate = c["results"] |> hd |> Map.get("candidates") |> hd |> Map.get("plate")
          acar = Car.changeset(%Car{}, %{"plate": plate, "detected_data": resp.body, "picture": img})
          {:ok, _} = Repo.insert(acar)
          conn
          |> json(%{msg: "hello", plate: plate, data: c})
        else
          Logger.info("reuslt == []")
          conn |>
          json(%{errMag: "no found plate"})
        end
      :error ->
        Logger.info(":error")
        IO.inspect resp
        conn
        |> json(%{errMsg: "api request failed"})
    end
  end

  def uploadImg(conn, params) do
    name = Map.get(params, "name")
    avatar = queryAvatarByName(name)
    img = Map.get(params, "img")
    if is_nil(avatar) do
      Logger.info("api failed")
      conn
      |> json(%{errMsg: "api failed", name: name})
    else
      openalpr_key = Application.get_env(:parp_server, :openalpr_key)
      {status, resp} = HTTPoison.post("https://api.openalpr.com/v2/recognize_bytes?secret_key=#{openalpr_key}&recognize_vehicle=0&country=us&return_image=0&topn=10", img, [{"Content-Type", "application/json"}])
      case status do
        :ok ->
          Logger.info(":ok")
          c = Poison.decode!(resp.body)
          results = c["results"]
          if results != [] do
            Logger.info("reuslt != []")
            plate = c["results"] |> hd |> Map.get("candidates") |> hd |> Map.get("plate")
            at = Avatar.findLastAtHistory(avatar)
            acar = Car.changeset(%Car{}, %{"plate": plate, "detected_data": resp.body, "picture": img})
            {:ok, catat} = Repo.insert(acar)
            Logger.info(":ok2")
            {:ok, t2} = AtHistory.changeset(at, %{"car_id": Map.get(catat, :id)}) |> Repo.update
            IO.inspect t2
            conn
            |> json(%{msg: "hello", plate: plate, data: c})
          else
            Logger.info("reuslt == []")
            conn |>
            json(%{errMag: "no found plate"})
          end
        :error ->
          Logger.info(":error")
          IO.inspect resp
          conn
          |> json(%{errMsg: "api failed"})
      end
    end
  end

  defp queryAvatarByName(name) do
    tmp = Repo.all(
      from avatar in Avatar,
      where: avatar.name == ^name
    )
    if tmp == [] do
      nil
    else
      hd(tmp)
    end
  end
end
