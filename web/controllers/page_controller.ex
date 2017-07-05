defmodule ParpServer.PageController do
  use ParpServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end
