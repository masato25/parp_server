defmodule ParpServer.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:session) do
      add :user_id, references(:user, on_delete: :delete_all)
      add :session_key, :string

      timestamps()
    end

  end
end
