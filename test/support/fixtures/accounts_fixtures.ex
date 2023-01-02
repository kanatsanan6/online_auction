defmodule OnlineAuction.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OnlineAuction.Accounts` context.
  """

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        encrypted_password: "some encrypted_password",
        username: unique_user_username()
      })
      |> OnlineAuction.Accounts.create_user()

    user
  end
end
