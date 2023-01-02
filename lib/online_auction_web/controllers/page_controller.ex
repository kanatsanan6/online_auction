defmodule OnlineAuctionWeb.PageController do
  use OnlineAuctionWeb, :controller

  def index(conn, _params) do
    Auth.check_auth(conn)

    render(conn, "index.html")
  end
end
