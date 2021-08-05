defmodule GoodVibes.Repo do
  use Ecto.Repo,
    otp_app: :good_vibes,
    adapter: Ecto.Adapters.Postgres
end
