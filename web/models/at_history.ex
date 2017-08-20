defmodule ParpServer.AtHistory do
  use ParpServer.Web, :model
  alias ParpServer.Repo
  @derive {Poison.Encoder, only: [:id, :start_at, :end_at, :status, :user_id, :parking_license, :price, :paid_status]}

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

  def findMyPayParking(uid) do
    Repo.all(
      from ath in ParpServer.AtHistory,
      where: ath.user_id == ^uid and (ath.paid_status == false or is_nil(ath.paid_status)) and not is_nil(ath.price),
      order_by: [desc: :end_at],
      limit: 1
    )
  end
end
