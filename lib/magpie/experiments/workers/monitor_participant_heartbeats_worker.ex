defmodule Magpie.Experiments.Workers.MonitorParticipantHeartbeatsWorker do
  @moduledoc """
  Reopens a slot if the participant for this slot hasn't reported heartbeat for more than 2 minutes.
  """
  use GenServer

  alias Magpie.Experiments.Slots

  @two_minutes 2 * 60 * 1000

  def start_link(opts) do
    interval = Keyword.get(opts, :interval, @two_minutes)
    GenServer.start_link(__MODULE__, [interval: interval], name: __MODULE__)
  end

  @impl true
  def init(state) do
    # Perform the action at application startup as well
    Slots.reset_statuses_for_inactive_complex_experiments()
    {:ok, schedule(state)}
  end

  @impl true
  def handle_cast(:reset_timer, state) do
    {:noreply, schedule(state)}
  end

  @impl true
  def handle_cast(:reset_statuses, state) do
    Slots.reset_statuses_for_inactive_complex_experiments()
    {:noreply, schedule(state)}
  end

  @impl true
  def handle_info(:reset_statuses, state) do
    Experiments.reset_statuses_for_inactive_complex_experiments()
    {:noreply, schedule(state)}
  end

  def handle_info(_, state), do: {:noreply, state}

  @doc """
  Manually trigger a database purge of inactive experiments. Also resets the current
  scheduled work.
  """
  def purge do
    GenServer.cast(__MODULE__, :reset_statuses)
  end

  @doc """
  Reset the purge timer.
  """
  def reset_timer do
    GenServer.cast(__MODULE__, :reset_timer)
  end

  defp schedule(opts) do
    if timer = Keyword.get(opts, :timer), do: Process.cancel_timer(timer)

    interval = Keyword.get(opts, :interval)
    timer = Process.send_after(self(), :reset_statuses, interval)

    [interval: interval, timer: timer]
  end
end
