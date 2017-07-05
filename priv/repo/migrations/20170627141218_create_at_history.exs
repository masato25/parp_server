defmodule ParpServer.Repo.Migrations.CreateAtHistory do
  use Ecto.Migration

  def change do
    create table(:at_history) do
      add :start_at, :naive_datetime
      add :end_at, :naive_datetime
      add :status, :string
      add :avatar_id, references(:avatar, on_delete: :nothing)

      timestamps()
    end

  end
end
