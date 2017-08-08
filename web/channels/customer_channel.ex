defmodule ParpServer.CustomerChannel do
  use Phoenix.Channel
  require Logger
  alias TaipieMediaCon.DBHelp.AvatarHelper
  alias ParpServer.Helper.AvatarOps

  def join("customer:lobby", params, socket) do
    {:ok, %{message: "hello"}, socket}
  end

  def join("customer:" <> user_id, _params, socket) do
    {:ok, %{message: "hello: #{user_id}"}, socket}
  end

  def terminate(msg, socket) do
		Logger.info("user left")
    {:shutdown, :left}
  end
end
