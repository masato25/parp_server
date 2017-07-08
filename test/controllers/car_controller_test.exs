defmodule ParpServer.CarControllerTest do
  use ParpServer.ConnCase

  alias ParpServer.Car
  @valid_attrs %{detected_data: "some content", plate: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, car_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    car = Repo.insert! %Car{}
    conn = get conn, car_path(conn, :show, car)
    assert json_response(conn, 200)["data"] == %{"id" => car.id,
      "plate" => car.plate,
      "detected_data" => car.detected_data}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, car_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, car_path(conn, :create), car: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Car, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, car_path(conn, :create), car: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    car = Repo.insert! %Car{}
    conn = put conn, car_path(conn, :update, car), car: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Car, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    car = Repo.insert! %Car{}
    conn = put conn, car_path(conn, :update, car), car: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    car = Repo.insert! %Car{}
    conn = delete conn, car_path(conn, :delete, car)
    assert response(conn, 204)
    refute Repo.get(Car, car.id)
  end
end
