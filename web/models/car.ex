defmodule ParpServer.Car do
  use ParpServer.Web, :model

  schema "cat" do
    field :plate, :string
    field :detected_data, :string
    field :picture, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:plate, :detected_data, :picture])
    |> validate_required([:plate, :detected_data, :picture])
  end
end
