defmodule MagpieWeb.ExperimentResultControllerTest do
  use MagpieWeb.ConnCase

  import Magpie.ExperimentsFixtures

  # describe "create experiment_result" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.experiment_path(conn, :create), experiment: @create_attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.experiment_path(conn, :show, id)

  #     conn = get(conn, Routes.experiment_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Experiment"
  #   end
  # end
end
