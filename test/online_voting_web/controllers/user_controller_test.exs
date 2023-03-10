defmodule OnlineVotingWeb.UserControllerTest do
  use OnlineVotingWeb.ConnCase

  import OnlineVoting.AccountsFixtures

  @create_attrs %{encrypted_password: "some encrypted_password", username: "some username"}
  @update_attrs %{
    encrypted_password: "some updated encrypted_password",
    username: "some updated username"
  }
  @invalid_attrs %{encrypted_password: nil, username: nil}

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "Registration"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.item_index_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Registration"
    end
  end
end
