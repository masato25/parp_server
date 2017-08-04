defmodule ParpServer.CreateUser do
  use ExUnit.Case
  require Logger

  @jsonheader {"Content-Type", "application/json"}
  setup context do
    hosturi = "http://localhost:4000"
    {:ok, hosturi: hosturi}
  end

  #create user
  @tag create: ""
  test "create user", %{hosturi: hosturi} do
    pbody = Poison.encode!(%{user: %{
        name: "司馬亭", gender: "male", birthday: "1985-07-22",
        parking_license: "AP-0012", password: "p00123", username: "parpuser1"
      }
    })
    resp = HTTPoison.post!("#{hosturi}/api/v1/user", pbody, [@jsonheader])
    Poison.encode!(resp.body) |> Logger.warn
  end

  #login user
  @tag login: ""
  test "login user", %{hosturi: hosturi} do
    pbody = Poison.encode!(%{username: "parpuser1", password: "p00123"})
    resp = HTTPoison.post!("#{hosturi}/api/v1/login", pbody, [@jsonheader])
    Poison.encode!(resp.body) |> Logger.warn
  end

  #session check & get current user info
  @tag sessioncheck: ""
  test "session check user", %{hosturi: hosturi} do
    pbody = Poison.encode!(%{username: "parpuser1", token: "X56HtazXHoZEB-Hb"})
    resp = HTTPoison.post!("#{hosturi}/api/v1/current_user", pbody, [@jsonheader])
    Poison.encode!(resp.body) |> Logger.warn
  end
end
