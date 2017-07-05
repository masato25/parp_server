defmodule ParpServer.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :gender, :string
      add :birthday, :string
      add :parking_license, :string
      add :reservation, :integer

      timestamps()
    end

  end
end
