defmodule Veranxiety.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VeranxietyWeb.Telemetry,
      Veranxiety.Repo,
      {DNSCluster, query: Application.get_env(:veranxiety, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Veranxiety.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Veranxiety.Finch},
      # Start a worker by calling: Veranxiety.Worker.start_link(arg)
      # {Veranxiety.Worker, arg},
      # Start to serve requests, typically the last entry
      VeranxietyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Veranxiety.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VeranxietyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
