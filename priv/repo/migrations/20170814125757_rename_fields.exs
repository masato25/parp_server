defmodule ParpServer.Repo.Migrations.RenameFields do
  use Ecto.Migration

  def change do
    alter table(:avatar) do
      remove :bluetooth_status
      remove :bluetooth_type
    end
    rename table(:avatar), :sensor_id, to: :sensor_id
  end
end
