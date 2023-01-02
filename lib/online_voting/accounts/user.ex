defmodule OnlineVoting.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2

  schema "users" do
    field :encrypted_password, :string
    field :username, :string
    many_to_many :topics, OnlineVoting.Votings.Topic, join_through: "topics_users"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :encrypted_password])
    |> validate_required([:username, :encrypted_password])
    |> unique_constraint(:username)
    |> update_change(:encrypted_password, &Argon2.hash_pwd_salt/1)
  end
end
