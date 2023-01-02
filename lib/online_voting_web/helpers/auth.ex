defmodule OnlineVotingWeb.Helpers.Auth do
  use OnlineVotingWeb, :helper

  alias OnlineVoting.Accounts

  require Logger

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!OnlineVoting.Repo.get(OnlineVoting.Accounts.User, user_id)
  end

  def check_auth(conn) do
    if user_id = Plug.Conn.get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)

      conn
      |> assign(:current_user, current_user)
    else
      conn
      |> put_flash(:error, "You need to be logged in")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
