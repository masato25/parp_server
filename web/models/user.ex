defmodule ParpServer.User do
  use ParpServer.Web, :model
  import Logger

  schema "user" do
    field :name, :string
    field :gender, :string
    field :birthday, :string
    field :parking_license, :string
    field :password, :string
    field :username, :string
    field :payment, :string
    has_many :sessions, ParpServer.Session

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :gender, :birthday, :parking_license, :password, :payment, :username])
    |> validate_required([:name, :username, :parking_license])
    |> unique_constraint(:username)
    |> hashpassword()
  end

  def changeset_update(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :gender, :birthday, :parking_license, :password, :payment, :username])
    |> unique_constraint(:username)
    |> hashpassword()
  end

  defp hashpassword(data) do
    pmap = Map.get(data, :changes, %{})
    passwd = Map.get(data.changes, :password, "")
    Logger.warn "passwd: #{passwd}"
    if passwd != "" do
      passwd = encoding(passwd)
      pmap = Map.put(pmap, :password, passwd)
    end
    Map.put(data, :changes, pmap)
  end

  def encoding(password_paintext) do
     :crypto.hash(:md5, password_paintext <> getsalt()) |> Base.encode16()
  end

  defp getsalt() do
    Application.get_env(:ParpServer, :pass_salt) || ""
  end

end
