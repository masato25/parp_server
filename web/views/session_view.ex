defmodule ParpServer.SessionView do
  use ParpServer.Web, :view

  def render("index.json", %{session: session}) do
    %{data: render_many(session, ParpServer.SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, ParpServer.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      user_id: session.user_id,
      session_key: session.session_key}
  end

  # to help gen user info #
  def render("showwithsession.json", %{user: user, session: session}) do
    %{data: render_one(user, ParpServer.UserView, "user.json"), session: %{username: user.username, session: session.session_key}}
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

end
