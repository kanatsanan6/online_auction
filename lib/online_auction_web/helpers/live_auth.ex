defmodule OnlineAuctionWeb.Helpers.LiveAuth do
  alias OnlineAuction.Accounts
  import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    if !is_nil(session["current_user_id"]) do
      current_user = Accounts.get_user!(session["current_user_id"])

      socket
      |> assign(:current_user, current_user)

      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/sign-in")}
    end
  end
end
