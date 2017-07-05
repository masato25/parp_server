defmodule ParpServer.AtHistoryTest do
  use ParpServer.ModelCase

  alias ParpServer.AtHistory

  @valid_attrs %{end_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, status: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AtHistory.changeset(%AtHistory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AtHistory.changeset(%AtHistory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
