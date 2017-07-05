defmodule ParpServer.AtHistoryControllerTest do
  use ParpServer.ConnCase

  alias ParpServer.AtHistory
  @valid_attrs %{end_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, status: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, at_history_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    at_history = Repo.insert! %AtHistory{}
    conn = get conn, at_history_path(conn, :show, at_history)
    assert json_response(conn, 200)["data"] == %{"id" => at_history.id,
      "start_at" => at_history.start_at,
      "end_at" => at_history.end_at,
      "status" => at_history.status,
      "avatar_id" => at_history.avatar_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, at_history_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, at_history_path(conn, :create), at_history: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AtHistory, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, at_history_path(conn, :create), at_history: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    at_history = Repo.insert! %AtHistory{}
    conn = put conn, at_history_path(conn, :update, at_history), at_history: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AtHistory, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    at_history = Repo.insert! %AtHistory{}
    conn = put conn, at_history_path(conn, :update, at_history), at_history: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    at_history = Repo.insert! %AtHistory{}
    conn = delete conn, at_history_path(conn, :delete, at_history)
    assert response(conn, 204)
    refute Repo.get(AtHistory, at_history.id)
  end
end
