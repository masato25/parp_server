defmodule ParpServer.UserView do
  use ParpServer.Web, :view

  def render("index.json", %{user: user}) do
    %{data: render_many(user, ParpServer.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, ParpServer.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      gender: user.gender,
      birthday: user.birthday,
      parking_license: user.parking_license}
  end
end
