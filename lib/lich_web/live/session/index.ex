defmodule LichWeb.Session.Index do
  use LichWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, node: Node.self())}
  end

  def render(assigns) do
    ~H"""
    <div>LiveView connected to: <span class="text-blue-500"><%= @node %></span></div>
    """
  end
end
