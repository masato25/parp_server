defmodule ParpServer.Repo.Migrations.CreateCar do
  use Ecto.Migration

  def change do
    create table(:cat) do
      add :plate, :string
      add :detected_data, :text
      add :picture, :text

      timestamps()
    end

  end
end
