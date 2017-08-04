defmodule ParpServer.Repo.Migrations.AddFieldsToUser do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :password, :string
      add :username, :string
      add :payment, :string
    end
    create unique_index(:user, [:username])

    alter table(:avatar) do
      add :reservation_at, :naive_datetime
    end

  end
end
