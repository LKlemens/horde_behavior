defmodule HordeBehavior.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      local_epmd: [
        strategy: Elixir.Cluster.Strategy.LocalEpmd
      ]
    ]

    children = [
      {Horde.Registry, [name: Registry.Boom, keys: :unique, members: :auto]},
      {Horde.Registry, [name: Registry.State, keys: :unique, members: :auto]},
      {Cluster.Supervisor, [topologies, [name: CsBonusesService.ClusterSupervisor]]},
      %{
        id: Agent,
        start:
          {Agent, :start_link,
           [fn -> [] end, [name: {:via, Horde.Registry, {Registry.State, node()}}]]}
      }
      # Starts a worker by calling: HordeBehavior.Worker.start_link(arg)
      # {HordeBehavior.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HordeBehavior.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
