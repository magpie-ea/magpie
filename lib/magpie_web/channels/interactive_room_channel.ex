defmodule MagpieWeb.InteractiveRoomChannel do
  @moduledoc """
  Channel for maintaining lobbies in interactive experiments which require multiple participants to with each other.

  The client should make use of the presence_diff event to decide if a game can be started.
  """

  use MagpieWeb, :channel
  alias MagpieWeb.Presence

  alias Magpie.Experiments

  @doc """
  Let the participant join the lobby and wait in there.

  One lobby is created for a particular slot_identifier.
  """
  def join(
        "interactive_room:" <> room_identifier,
        %{"slot_identifier" => full_slot_identifier},
        socket
      ) do
    experiment_id = socket.assigns.experiment_id
    [_copy, slot_identifier, _player] = String.split(full_slot_identifier, "_")

    expected_room_identifier = "#{experiment_id}:#{slot_identifier}"

    if room_identifier == expected_room_identifier do
      send(self(), :after_participant_join)

      {:ok, assign(socket, :slot_identifier, full_slot_identifier)}
    else
      {:error, %{reason: "invalid_format"}}
    end
  end

  def handle_info(:after_participant_join, socket) do
    # Add this participant to the list of all participants waiting in the lobby of this experiment.
    # This Presence can also be helpful in informing participants when one participant drops out.

    [_copy, identifier, _player] = String.split(socket.assigns.slot_identifier, "_")

    Presence.track(
      socket,
      "#{identifier}",
      %{
        participant_id: socket.assigns.participant_id,
        online_at: inspect(System.system_time(:second))
      }
    )

    # Note that the presence information will be returned as a map with presences *grouped by key*, together with the metadata.
    # Example:
    # %{
    #   "1:1:1:1" => %{
    #     metas: [
    #       %{
    #         online_at: "1629644124",
    #         participant_id: "b31e54b0e558d3a87fd3cd9530d07e297fe00d86",
    #         phx_ref: "Fp2osoV59TjSYAFE"
    #       },
    #       %{
    #         online_at: "1629644128",
    #         participant_id: "54080b46f09162477e36e05e22ad4f8aa9dda49f",
    #         phx_ref: "Fp2os3i8kgDSYAHE"
    #       }
    #     ]
    #   }
    # }
    # To get the participants, we first go by the topic name, then go under :meta
    existing_participants =
      socket
      |> Presence.list()
      |> Map.get(identifier)
      |> Map.get(:metas)

    # Start the experiment if the predefined number of players is reached.
    # We could also send a presence_state event to the clients. Though this is the easy way to do it.
    # We need to get the number of players via slot_trial_num_players.

    num_participants =
      Experiments.get_num_participants_for_slot(
        socket.assigns.experiment_id,
        socket.assigns.slot_identifier
      )

    if length(existing_participants) >= num_participants do
      group_label = Base.encode64(:crypto.strong_rand_bytes(20))
      broadcast!(socket, "start_game", %{"group_label" => group_label})
    end

    {:noreply, socket}
  end

  # This handles new messages from the clients and broadcast them to everybody susbcribed to the same topic (i.e. who joined the same lounge).
  def handle_in("new_msg", payload, socket) do
    broadcast(socket, "new_msg", payload)
    {:noreply, socket}
  end

  # In many cases the game initialization needs to be handled by the client, since the server remains as generic as possible and just provides a channel for communication.
  # The client can always use `new_msg` for everything, though specialized message types could help ease the job.
  def handle_in("initialize_game", payload, socket) do
    broadcast(socket, "initialize_game", payload)
    {:noreply, socket}
  end

  # Message indicating that the game is to be advanced to the next round.
  def handle_in("next_round", payload, socket) do
    broadcast(socket, "next_round", payload)
    {:noreply, socket}
  end

  # Message indicating that the game has ended.
  def handle_in("end_game", payload, socket) do
    broadcast(socket, "end_game", payload)
    {:noreply, socket}
  end
end
