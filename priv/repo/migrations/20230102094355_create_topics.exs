defmodule OnlineVoting.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :name, :string
      add :agreed, :integer, default: 0
      add :disagreed, :integer, default: 0

      timestamps()
    end
  end
end
