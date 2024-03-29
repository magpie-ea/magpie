defmodule Magpie.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Magpie.Repo,
      # Start the Telemetry supervisor
      MagpieWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Magpie.PubSub},
      MagpieWeb.Presence,
      # Start the Endpoint (http/https)
      MagpieWeb.Endpoint,
      {MagpieWeb.ParticipantWatcher, :participants},
      {Magpie.Experiments.WaitingQueueWorker, []},
      {Magpie.Experiments.AssignExperimentSlotsWorker, []},
      {Magpie.Experiments.MonitorParticipantHeartbeatsWorker, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Magpie.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MagpieWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
