defmodule OnlineVoting.Repo do
  use Ecto.Repo,
    otp_app: :online_voting,
    adapter: Ecto.Adapters.Postgres
end
