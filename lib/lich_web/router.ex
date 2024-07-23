defmodule LichWeb.Router do
  use LichWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LichWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LichWeb do
    pipe_through :browser

    live "/", Session.Index
  end

  import Phoenix.LiveDashboard.Router

  scope "/dev" do
    pipe_through :browser

    live_dashboard "/dashboard", metrics: LichWeb.Telemetry
    forward "/mailbox", Plug.Swoosh.MailboxPreview
  end
end
