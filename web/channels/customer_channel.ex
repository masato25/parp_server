defmodule ParpServer.CustomerChannel do
  use Phoenix.Channel
  require Logger
  alias TaipieMediaCon.DBHelp.AvatarHelper
  alias ParpServer.Helper.AvatarOps
  alias ParpServer.AtHistory
  alias ParpServer.Avatar
  alias ParpServer.Repo

  def join("customer:lobby", params, socket) do
    {:ok, %{message: "hello"}, socket}
  end

  def join("customer:" <> user_id, _params, socket) do
    payinfo = AtHistory.findMyPayParking(user_id)
    if payinfo != [] do
      payinfo = hd(payinfo)
      payid = Map.get(payinfo, :id)
      mprice = Map.get(payinfo, :price)
      mavatar_id = Map.get(payinfo, :avatar_id)
      avatar = findAvatar(mavatar_id)
      {:ok, %{message: "hello: #{user_id}", price_pay_info: %{id: payid, price: mprice, avatar_id: mavatar_id}, avatar: avatar}, socket}
    else
      {:ok, %{message: "hello: #{user_id}"}, socket}
    end
  end

  def findAvatar(id) do
    avatar = Repo.get!(Avatar, id)
    if is_nil(avatar) do
      nil
    else
      coordinate = Map.get(avatar, :coordinate)
      custom_name = Map.get(avatar, :custom_name)
      name = Map.get(avatar, :name)
      sensor_id = Map.get(avatar, :sensor_id)
      %{sensor_id: sensor_id, coordinate: coordinate, custom_name: custom_name, name: name}
    end
  end

  def terminate(msg, socket) do
		Logger.info("user left")
    {:shutdown, :left}
  end

  def noticeUserPay(uid) do
    payinfo = AtHistory.findMyPayParking(uid)
    if payinfo != [] do
      payinfo = hd(payinfo)
      payid = Map.get(payinfo, :id)
      mprice = Map.get(payinfo, :price)
      mavatar_id = Map.get(payinfo, :avatar_id)
      avatar = findAvatar(mavatar_id)
      pst = %{price_pay_info: %{id: payid, price: mprice, avatar_id: mavatar_id}, avatar: avatar}
      resbody = Poison.encode!(pst)
      ParpServer.Endpoint.broadcast!("customer:#{uid}", "payment_request", pst)
    else
      Logger.error("noticeUserPay got error, uid: #{uid}")
    end
  end
end
