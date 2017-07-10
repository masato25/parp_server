defmodule ParpServer.Repo.Migrations.AddPriceSetAvatar do
  use Ecto.Migration

  def change do
    alter table(:avatar) do
      add :price_set, :string, default: " / 3600 * 20"
    end
  end
end
