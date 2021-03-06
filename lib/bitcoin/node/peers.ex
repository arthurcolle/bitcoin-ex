defmodule Bitcoin.Node.Peers do
  use Supervisor

  @discovery_service Bitcoin.Node.Peers.Discovery
  @peer_connection_pool_service Bitcoin.Node.Peers.ConnectionPool

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      supervisor(Reagent, [@peer_connection_pool_service, [name: @peer_connection_pool_service, port: 0]]), # the OS will pick a port on which we should listen
      supervisor(@discovery_service, [[name: @discovery_service, peer_connection_pool: @peer_connection_pool_service]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end