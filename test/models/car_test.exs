defmodule ParpServer.CarTest do
  use ParpServer.ModelCase

  alias ParpServer.Car

  @valid_attrs %{detected_data: "some content", plate: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Car.changeset(%Car{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Car.changeset(%Car{}, @invalid_attrs)
    refute changeset.valid?
  end
end
