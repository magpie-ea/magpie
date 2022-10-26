defmodule MagpieWeb.Presence do
  @moduledoc false
  use Phoenix.Presence, otp_app: :magpie, pubsub_server: Magpie.PubSub
end
