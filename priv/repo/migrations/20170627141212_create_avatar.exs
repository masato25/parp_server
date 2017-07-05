defmodule ParpServer.Repo.Migrations.CreateAvatar do
  use Ecto.Migration

  def change do
    create table(:avatar) do
      add :name, :string
      add :address, :string
      add :bluetooth_status, :integer
      add :bluetooth_type, :integer
      add :latitude_longitude, :string
      add :custom_name, :string
      add :latest_report, :naive_datetime

      timestamps()
    end
    create unique_index(:avatar, [:address], unique: true)
  end
end