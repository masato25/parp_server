defmodule ParpServer.Repo.Migrations.AddFieldsToAtHistory do
  use Ecto.Migration

  def change do
    alter table(:at_history) do
      add :user_id, :integer
      add :parking_license, :string
      add :price, :integer
      add :paid_status, :boolean
    end
  end
end
