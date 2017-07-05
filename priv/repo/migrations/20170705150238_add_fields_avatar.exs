defmodule ParpServer.Repo.Migrations.AddFieldsAvatar do
  use Ecto.Migration

  def change do
    alter table(:avatar) do
      add :coordinate, :string
    end
  end
end
