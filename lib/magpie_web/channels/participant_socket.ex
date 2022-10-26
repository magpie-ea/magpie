defmodule MagpieWeb.ParticipantSocket do
  use Phoenix.Socket

  alias Magpie.Experiments

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels
  # Participant Channel is responsible for holding 1-to-1 connections with each participant.
  # The ":*" part just means that any event with `participant` topic will be sent to the Participant channel.
  channel("participant:*", MagpieWeb.ParticipantChannel)
  channel("interactive_room:*", MagpieWeb.InteractiveRoomChannel)

  @impl true
  def connect(%{"participant_id" => participant_id, "experiment_id" => experiment_id}, socket) do
    with false <- participant_id == "",
         experiment <- Experiments.get_experiment!(experiment_id),
         true <- experiment.active do
      {:ok,
       socket
       |> assign(:participant_id, participant_id)
       |> assign(:experiment_id, experiment_id)}
    else
      # It seems that socket doesn't allow for sending specialized error messages. Just send :error
      _ -> :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.MagpieWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(socket), do: "participant_socket:#{socket.assigns.participant_id}"
end
