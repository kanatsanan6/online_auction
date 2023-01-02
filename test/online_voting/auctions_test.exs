defmodule OnlineVoting.AuctionsTest do
  use OnlineVoting.DataCase

  alias OnlineVoting.Auctions

  describe "items" do
    alias OnlineVoting.Auctions.Item

    import OnlineVoting.AuctionsFixtures

    @invalid_attrs %{name: nil, price: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Auctions.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Auctions.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{name: "some name", price: 42}

      assert {:ok, %Item{} = item} = Auctions.create_item(valid_attrs)
      assert item.name == "some name"
      assert item.price == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auctions.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{name: "some updated name", price: 43}

      assert {:ok, %Item{} = item} = Auctions.update_item(item, update_attrs)
      assert item.name == "some updated name"
      assert item.price == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Auctions.update_item(item, @invalid_attrs)
      assert item == Auctions.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Auctions.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Auctions.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Auctions.change_item(item)
    end
  end
end
