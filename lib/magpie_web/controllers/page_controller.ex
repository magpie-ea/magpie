defmodule MagpieWeb.PageController do
  use MagpieWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
