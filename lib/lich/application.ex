defmodule Lich.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LichWeb.Telemetry,
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: Lich.ClusterSupervisor]]},
      # {DNSCluster, query: Application.get_env(:lich, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Lich.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Lich.Finch},
      # Start a worker by calling: Lich.Worker.start_link(arg)
      # {Lich.Worker, arg},
      # Start to serve requests, typically the last entry
      {Horde.DynamicSupervisor,
       name: Lich.SessionSupervisor, strategy: :one_for_one, members: :auto},
      {Horde.Registry, keys: :unique, name: Lich.SessionRegistry, members: :auto},
      LichWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lich.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LichWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
