defmodule GoodVibes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GoodVibes.Repo,
      # Start the Telemetry supervisor
      GoodVibesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GoodVibes.PubSub},
      # Start the Endpoint (http/https)
      GoodVibesWeb.Endpoint
      # Start a worker by calling: GoodVibes.Worker.start_link(arg)
      # {GoodVibes.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GoodVibes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GoodVibesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
