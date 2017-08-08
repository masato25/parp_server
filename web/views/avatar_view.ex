defmodule ParpServer.AvatarView do
  use ParpServer.Web, :view
  alias ParpServer.Helper.TimeUtils,  as: TS

  def render("index.json", %{avatar: avatar}) do
    %{data: render_many(avatar, ParpServer.AvatarView, "avatar.json")}
  end

  def render("show.json", %{avatar: avatar}) do
    %{data: render_one(avatar, ParpServer.AvatarView, "avatar.json")}
  end

  def render("avatar.json", %{avatar: avatar}) do
    reservation_at = nil
    if !is_nil(avatar.reservation_at) do
       reservation_at = TS.convertNaiveToUnix(avatar.reservation_at)
    end
    %{
      id: avatar.id,
      user_id: avatar.user_id,
      name: avatar.name,
      custom_name: avatar.custom_name,
      address: avatar.address,
      bluetooth_status: avatar.bluetooth_status,
      bluetooth_type: avatar.bluetooth_type,
      inserted_at: converTime(avatar.inserted_at),
      latest_report: converTime(avatar.latest_report),
      coordinate: avatar.coordinate,
      price_set: avatar.price_set,
      parking_status: avatar.parking_status,
      reservation_at: reservation_at
    }
  end

  defp converTime(timeTs) do
    TS.naiveTimeConver(timeTs)
  end

end
