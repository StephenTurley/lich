defmodule Lich.Session do
  use GenServer

  @impl true
  def init(session_name: name) do
    {:ok, %{counter: 0, name: name}}
  end

  def start_link(session_name) do
    opts = [
      session_name: session_name,
      name: {:via, Horde.Registry, {Lich.SessionRegistry, session_name}}
    ]

    Horde.DynamicSupervisor.start_child(Lich.SessionSupervisor, {__MODULE__, opts})
  end
end
