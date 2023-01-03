defmodule OnlineVoting.AccountsTest do
  use OnlineVoting.DataCase

  alias OnlineVoting.Accounts

  alias Argon2

  describe "users" do
    alias OnlineVoting.Accounts.User

    import OnlineVoting.AccountsFixtures

    @invalid_attrs %{encrypted_password: nil, username: nil}

    test "get_by_username/0 returns a user with given username" do
      user = user_fixture()
      assert Accounts.get_by_username(user.username) == user
    end

    test "get_by_username/1 returns nil with nil given username" do
      assert Accounts.get_by_username(nil) == nil
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{encrypted_password: "some encrypted_password", username: "some username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.encrypted_password =~ "argon"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        encrypted_password: "some updated encrypted_password",
        username: "some updated username"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.encrypted_password =~ "argon"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
