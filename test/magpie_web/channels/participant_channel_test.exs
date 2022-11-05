defmodule MagpieWeb.ParticipantChannelTest do
  use MagpieWeb.ChannelCase

  setup do
    create_participant_and_take_slot()
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
