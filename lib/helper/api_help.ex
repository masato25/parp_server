defmodule ParpServer.Helper.ApiHelp do

  def getSessionFromHeader(conn) do
    reqh = Map.get(conn, :req_headers, "")
    if reqh == "" do
      -1
    else
      getHd = reqh |> Enum.filter(fn o ->
        String.contains?(elem(o,0), "authorization")
      end)
      if getHd == [] do
        -1
      else
        [username, session_key] = getHd |> hd |> elem(1) |> String.split(" ")
        %{username: username, token: session_key}
      end
    end
  end
end
