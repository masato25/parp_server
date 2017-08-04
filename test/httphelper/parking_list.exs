defmodule ParpServer.ParkingList do
  use ExUnit.Case
  require Logger

  @jsonheader {"Content-Type", "application/json"}
  setup context do
    hosturi = "http://localhost:4000"
    {:ok, hosturi: hosturi}
  end

  #create user
  @tag status: "all"
  test "all parking place", %{hosturi: hosturi} do
    resp = HTTPoison.get!("#{hosturi}/api/v1/get_car_list")
    Poison.encode!(resp.body) |> Logger.warn
  end

  @tag status: "parking"
  test "parking place with parking", %{hosturi: hosturi} do
    resp = HTTPoison.get!("#{hosturi}/api/v1/get_car_list?status=parking")
    Poison.encode!(resp.body) |> Logger.warn
  end

  @tag status: "available"
  test "parking place with available", %{hosturi: hosturi} do
    resp = HTTPoison.get!("#{hosturi}/api/v1/get_car_list?status=available")
    Poison.encode!(resp.body) |> Logger.warn
  end

end
