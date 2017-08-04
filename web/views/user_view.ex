defmodule ParpServer.UserView do
  use ParpServer.Web, :view

  def render("index.json", %{user: user}) do
    %{data: render_many(user, ParpServer.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, ParpServer.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      name: user.name,
      gender: user.gender,
      birthday: user.birthday,
      parking_license: user.parking_license,
      payment: user.payment
    }
  end

  def render("showwithsession.json", %{user: user, session: session}) do
    %{data: render_one(user, ParpServer.UserView, "user.json"), session: %{username: user.username, session: session.session_key}}
  end
end
