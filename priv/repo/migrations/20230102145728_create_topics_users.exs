defmodule OnlineVoting.Repo.Migrations.CreateTopicsUsers do
  use Ecto.Migration

  def change do
    create table(:topics_users) do
      add :topic_id, references(:topics)
      add :user_id, references(:users)
    end

    create unique_index(:topics_users, [:topic_id, :user_id])
  end
end
