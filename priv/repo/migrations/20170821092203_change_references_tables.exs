defmodule ParpServer.Repo.Migrations.ChangeReferencesTables do
  use Ecto.Migration

  def up do
    drop constraint(:at_history, :at_history_avatar_id_fkey)
    alter table(:at_history) do
      modify :avatar_id, references(:avatar, name: :at_history_avatar_fk, on_delete: :delete_all)
    end
  end
end
