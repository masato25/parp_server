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
    %{
      id: avatar.id,
      name: avatar.name,
      custom_name: avatar.custom_name,
      address: avatar.address,
      bluetooth_status: avatar.bluetooth_status,
      bluetooth_type: avatar.bluetooth_type,
      inserted_at: converTime(avatar.inserted_at),
      latest_report: converTime(avatar.latest_report),
      coordinate: avatar.coordinate,
      price_set: avatar.price_set
    }
  end

  defp converTime(timeTs) do
    TS.naiveTimeConver(timeTs)
  end

end
