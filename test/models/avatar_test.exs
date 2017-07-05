defmodule ParpServer.AvatarTest do
  use ParpServer.ModelCase

  alias ParpServer.Avatar

  @valid_attrs %{address: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Avatar.changeset(%Avatar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Avatar.changeset(%Avatar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
