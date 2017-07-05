defmodule ParpServer.AtHistory do
  use ParpServer.Web, :model

  schema "at_history" do
    field :start_at, :naive_datetime
    field :end_at, :naive_datetime
    field :status, :string
    belongs_to :avatar, ParpServer.Avatar

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_at, :end_at, :status, :avatar_id])
    |> validate_required([:status])
  end
end
