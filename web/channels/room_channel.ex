defmodule ParpServer.RoomChannel do
  use Phoenix.Channel
  require Logger
  alias TaipieMediaCon.DBHelp.AvatarHelper
  alias ParpServer.Helper.AvatarOps

  def join("rooms:lobby", params, socket) do
		Logger.info("hello")
    {:ok, %{message: "hello"}, socket}
  end

  def join("rooms:" <> _private_rooom_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("car:parking", params, socket) do
    Logger.info("socket: #{inspect socket}")
    Logger.info("socket: #{inspect params}")
    AvatarOps.create(params)
    {:noreply, socket}
  end

  def handle_in("car:leave", params, socket) do
    Logger.info("socket: #{inspect socket}")
    Logger.info("socket: #{inspect params}")
    AvatarOps.level_parking(params)
    {:noreply, socket}
  end


  def terminate(msg, socket) do
		Logger.info("user left")
    {:shutdown, :left}
  end
end
