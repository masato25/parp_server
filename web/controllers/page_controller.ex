defmodule ParpServer.PageController do
  use ParpServer.Web, :controller
  require Logger

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
end
