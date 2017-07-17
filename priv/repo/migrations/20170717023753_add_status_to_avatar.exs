defmodule ParpServer.Repo.Migrations.AddStatusToAvatar do
  use Ecto.Migration

  def change do
    alter table(:avatar) do
      add :parking_status, :string, default: "available"
    end
  end
end
