defmodule OnlineAuction.AuctionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OnlineAuction.Auctions` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: 42
      })
      |> OnlineAuction.Auctions.create_item()

    item
  end
end
