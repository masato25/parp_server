defmodule ParpServer.Plug.SessionPlug do
  require Logger
  import Plug.Conn

  # those uri will, skip authorize session, ex. public page
  @skipUri ["/api/avatars", "/api/avatar_leave_pakring", "/api/avatar_no_found_update_all"]
  @loginUri ["/login"]

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    # check session first
    resp = sessionCheck(conn)
    cond do
      skipOn(conn) ->
        conn
      onLogin(conn) ->
        cond do
          # if owl session is vaild
          resp ->
            Logger.debug("session is vaild")
            conn
            |>  Phoenix.Controller.redirect(to: "/")
            |>  halt
          true ->
            conn
        end
      # other routes
      true ->
        cond do
          resp ->
            conn
          true ->
            conn
            |>  Phoenix.Controller.redirect(to: "/login")
            |>  halt
        end
    end
  end

  defp sessionCheck(conn) do
    extoken = conn.cookies["extoken"] || ""
    # check token ke is matched?
    extoken == Application.get_env(:parp_server, :token_key)
  end

  defp skipOn(conn) do
    reqUrl = conn.request_path
    reqUrl in @skipUri
  end

  defp onLogin(conn) do
    reqUrl = conn.request_path
    reqUrl in @loginUri
  end

end
