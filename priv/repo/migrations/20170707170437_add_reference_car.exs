defmodule ParpServer.Repo.Migrations.AddReferenceCar do
  use Ecto.Migration

  def change do
    alter table(:at_history) do
      add :car_id, :integer
    end
  end
end
