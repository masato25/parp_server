defmodule ParpServer.UserTest do
  use ParpServer.ModelCase

  alias ParpServer.User
  require Logger

  @valid_attrs %{birthday: "some content", gender: "some content", name: "some content", parking_license: "some content", password: "000"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  # test "test user create and return" do
  #   changeset = User.changeset(%User{}, @valid_attrs)
  #   IO.inspect changeset
  #   assert 0 == 0
  # end
end
