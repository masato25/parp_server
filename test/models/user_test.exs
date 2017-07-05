defmodule ParpServer.UserTest do
  use ParpServer.ModelCase

  alias ParpServer.User

  @valid_attrs %{birthday: "some content", gender: "some content", name: "some content", parking_license: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
