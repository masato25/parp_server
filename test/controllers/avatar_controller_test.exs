defmodule ParpServer.AvatarControllerTest do
  use ParpServer.ConnCase
  
  alias ParpServer.Avatar
  import Logger

  @lstime Ecto.DateTime.utc
  @valid_attrs %{address: "00:00:00:00", name: "nameA", bluetooth_type: 0, bluetooth_status: 0}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, avatar_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  #test "shows chosen resource", %{conn: conn} do
  #  avatar = Repo.insert! %Avatar{}
  #  conn = get conn, avatar_path(conn, :show, avatar)
  #  assert json_response(conn, 200)["data"] == %{"id" => avatar.id,
  #    "name" => avatar.name,
  #    "addr" => avatar.addr,
  #    "status" => avatar.status}
  #end

  #test "renders page not found when id is nonexistent", %{conn: conn} do
  #  assert_error_sent 404, fn ->
  #    get conn, avatar_path(conn, :show, -1)
  #  end
  #end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, avatar_path(conn, :create), avatar: @valid_attrs
    id = json_response(conn, 201)["data"]["id"]
    assert id
    assert Repo.get_by(Avatar, @valid_attrs)
    avatar = Map.put(@valid_attrs, :id, id)
    assert !is_nil(Avatar.createAtHistory(avatar))
    assert !is_nil(Avatar.findLastAtHistory(avatar))
  end

  #test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #  conn = post conn, avatar_path(conn, :create), avatar: @invalid_attrs
  #  assert json_response(conn, 422)["errors"] != %{}
  #end

  #test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #  avatar = Repo.insert! %Avatar{}
  #  conn = put conn, avatar_path(conn, :update, avatar), avatar: @valid_attrs
  #  assert json_response(conn, 200)["data"]["id"]
  #  assert Repo.get_by(Avatar, @valid_attrs)
  #end

  #test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #  avatar = Repo.insert! %Avatar{}
  #  conn = put conn, avatar_path(conn, :update, avatar), avatar: @invalid_attrs
  #  assert json_response(conn, 422)["errors"] != %{}
  #end

  #test "deletes chosen resource", %{conn: conn} do
  #  avatar = Repo.insert! %Avatar{}
  #  conn = delete conn, avatar_path(conn, :delete, avatar)
  #  assert response(conn, 204)
  #  refute Repo.get(Avatar, avatar.id)
  #end
end
