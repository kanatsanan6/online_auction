defmodule OnlineVotingWeb.SessionController do
  use OnlineVotingWeb, :controller

  alias OnlineVoting.Accounts
  alias OnlineVoting.Accounts.User

  alias Argon2

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    user = Accounts.get_by_username(user_params["username"])

    case Argon2.check_pass(user, user_params["encrypted_password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Log in successfully.")
        |> redirect(to: Routes.topic_index_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Username or Password is incorrect.")
        |> render("new.html", changeset: Accounts.change_user(%User{}))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Log out successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
