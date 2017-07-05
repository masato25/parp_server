defmodule ParpServer.User do
  use ParpServer.Web, :model

  schema "user" do
    field :name, :string
    field :gender, :string
    field :birthday, :string
    field :parking_license, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :gender, :birthday, :parking_license])
    |> validate_required([:name, :gender, :birthday, :parking_license])
  end
end
