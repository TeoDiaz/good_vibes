# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :good_vibes,
  ecto_repos: [GoodVibes.Repo]

# Configures the endpoint
config :good_vibes, GoodVibesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xwNiWHiR24QrQ3B6lYjt6KHoPTg7cUZyzs2wBsvKgJYZqBC766nNjQyOlQ3EQiqI",
  render_errors: [view: GoodVibesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GoodVibes.PubSub,
  live_view: [signing_salt: "8IS8tIvw"]

# Spreadsheet's configuration
config :good_vibes, GoodVibes.Spreadsheet.Repo.Http,
  spreadsheet_id: System.get_env("SPREADSHEET_ID")

config :goth, json: {:system, "GOOGLE_CREDENTIALS"}

# Google Spreadsheets configuration
config :elixir_google_spreadsheets, :client,
  request_workers: 5,
  max_demand: 10,
  max_interval: :timer.minutes(1),
  interval: 100,
  request_opts: [recv_timeout: :timer.seconds(10)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
