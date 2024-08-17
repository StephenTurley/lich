defmodule Lich do
  @moduledoc """
  Lich keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def list_sessions do
    Horde.DynamicSupervisor.which_children(Lich.SessionSupervisor) |> IO.inspect()
  end

  def create_session(name) do
    Lich.Session.start_link(name)
  end
end
