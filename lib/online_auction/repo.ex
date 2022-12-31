defmodule OnlineAuction.Repo do
  use Ecto.Repo,
    otp_app: :online_auction,
    adapter: Ecto.Adapters.Postgres
end
