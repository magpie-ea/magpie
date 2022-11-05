defmodule MagpieWeb.InteractiveRoomChannelTest do
  @moduledoc false
  use MagpieWeb.ChannelCase

  alias Magpie.Experiments

  setup do
    create_participant_and_take_slot()
  end

  test "joins the interactive room channel successfully", %{
    socket: socket
  } do
    [_copy, slot_identifier, _player] = String.split(socket.assigns.slot_identifier, "_")
    experiment_id = socket.assigns.experiment_id

    assert {:ok, _, _socket} =
             subscribe_and_join(
               socket,
               "interactive_room:#{experiment_id}-#{slot_identifier}"
             )
  end

  test "the newly joined user is tracked by Presence", %{
    socket: socket
  } do
    [_copy, slot_identifier, _player] = String.split(socket.assigns.slot_identifier, "_")
    experiment_id = socket.assigns.experiment_id

    assert {:ok, _, _socket} =
             subscribe_and_join(
               socket,
               "interactive_room:#{experiment_id}-#{slot_identifier}"
             )

    # Just test that it pushed out an event called "presence_diff". It seems to be not that easy to match against the payload body actually.
    assert_broadcast("presence_diff", %{})
  end

  test "start_game message is sent after the specified number of participants is reached" do
    experiment = Magpie.ExperimentsFixtures.ulc_experiment_fixture(%{num_players: 4})

    %{socket: socket} = create_participant_and_take_slot(experiment, "1_1:1:1_1")

    # First we need do join the first created participant to the channel
    [_copy, slot_identifier, _player] = String.split(socket.assigns.slot_identifier, "_")
    experiment_id = socket.assigns.experiment_id

    assert {:ok, _, _socket} =
             subscribe_and_join(
               socket,
               "interactive_room:#{experiment_id}-#{slot_identifier}"
             )

    num_participants =
      Experiments.get_num_participants_for_slot(
        socket.assigns.experiment_id,
        socket.assigns.slot_identifier
      )

    experiment = Experiments.get_experiment!(experiment_id)

    Enum.each(2..num_participants, fn count ->
      %{socket: socket} = create_participant_and_take_slot(experiment, "1_1:1:1_#{count}")

      [_copy, slot_identifier, _player] = String.split(socket.assigns.slot_identifier, "_")
      experiment_id = socket.assigns.experiment_id

      subscribe_and_join(
        socket,
        "interactive_room:#{experiment_id}-#{slot_identifier}"
      )
    end)

    assert_broadcast("start_game", %{"group_label" => _})
  end
end
