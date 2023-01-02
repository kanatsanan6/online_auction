defmodule OnlineAuction.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :agreed, :integer, default: 0
      add :disagreed, :integer, default: 0

      timestamps()
    end
  end
end
