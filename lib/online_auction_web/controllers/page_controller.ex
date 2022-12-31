defmodule OnlineAuctionWeb.PageController do
  use OnlineAuctionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
