defmodule OnlineAuction.Auctions.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :price, :integer
    field :timer, :integer

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end
end
