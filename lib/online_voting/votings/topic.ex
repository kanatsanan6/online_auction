defmodule OnlineVoting.Votings.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :name, :string
    field :agreed, :integer
    field :disagreed, :integer
    many_to_many :users, OnlineVoting.Accounts.User, join_through: "topics_users"

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:name, :agreed, :disagreed])
    |> validate_required([:name])
  end
end
