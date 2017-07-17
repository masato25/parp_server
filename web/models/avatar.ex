defmodule ParpServer.Avatar do
  use ParpServer.Web, :model
  import Logger
  alias ParpServer.AtHistory
  alias ParpServer.Helper.TimeUtils
  alias ParpServer.Repo

  schema "avatar" do
    field :name, :string
    field :address, :string
    field :bluetooth_status, :integer
    field :bluetooth_type, :integer
    field :latitude_longitude, :string
    field :custom_name, :string
    field :latest_report, :naive_datetime
    field :user_id, :integer
    field :coordinate, :string
    field :price_set, :string
    field :parking_status, :string

    has_many :av_history, AtHistory

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :custom_name, :address, :bluetooth_status, :bluetooth_type, :latest_report, :coordinate, :parking_status])
    |> validate_required([:address, :bluetooth_status, :name])
    |> unique_constraint(:address)
  end

  def setPakringStatus(avatar, status) do
    mychangeset = changeset(avatar, %{"parking_status": status})
    case Repo.update(mychangeset) do
      {:ok, avatar} ->
        avatar
      {:error, _} ->
        nil
    end
  end
  
  def createAtHistory(avatar) do
    avatar_id = Map.get(avatar, :id)
    changeset = AtHistory.changeset(%AtHistory{}, %{start_at: TimeUtils.naiveTimeNow(), status: "parking", avatar_id: avatar_id})
    case Repo.insert(changeset) do
      {:ok, ath} ->
        setPakringStatus(avatar, "parking")
        ath
      {:error, _} ->
        nil
    end
  end

  def findLastAtHistory(avatar) do
    avatar_id = Map.get(avatar, :id)
    parkone = Repo.all(
      from ath in AtHistory,
      where: ath.avatar_id == ^avatar_id and ath.status == "parking",
      order_by: [desc: :start_at],
      limit: 1
    )
    cond do
      parkone != [] ->
        hd(parkone)
      true ->
        nil
    end
  end
end
