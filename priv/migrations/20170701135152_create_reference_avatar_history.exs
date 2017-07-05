defmodule ParpServer.Repo.Migrations.CreateReferenceAvatarHistory do
  use Ecto.Migration

  def change do
    alter table(:avatar) do
      add :user_id, :integer
    end
  end

end
