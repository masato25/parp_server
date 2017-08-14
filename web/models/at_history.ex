defmodule ParpServer.AtHistory do
  use ParpServer.Web, :model

  schema "at_history" do
    field :start_at, :naive_datetime
    field :end_at, :naive_datetime
    field :status, :string
    field :car_id, :integer
    field :user_id, :integer
    field :parking_license, :string
    field :price, :integer
    field :paid_status, :boolean

    belongs_to :avatar, ParpServer.Avatar

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_at, :end_at, :status, :avatar_id, :car_id, :user_id, :parking_license, :price, :paid_status])
    |> validate_required([:status])
  end
end
