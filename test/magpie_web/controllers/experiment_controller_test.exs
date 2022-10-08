defmodule MagpieWeb.ExperimentControllerTest do
  use MagpieWeb.ConnCase

  import Magpie.ExperimentsFixtures

  @create_attrs %{
    author: "some author",
    name: "some name",
    description: "some description",
    active: true,
    is_ulc: true,
    ulc_num_chains: 2,
    ulc_num_generations: 2,
    ulc_num_players: 2,
    ulc_num_variants: 2,
    expansion_strategy: :expansive
  }
  @invalid_attrs %{
    author: "some author",
    name: "some name",
    description: "some description",
    active: true,
    is_ulc: true,
    ulc_num_chains: -1,
    ulc_num_generations: 0,
    ulc_num_players: -100,
    ulc_num_variants: -50,
    expansion_strategy: :expansive
  }

  describe "index" do
    test "lists all experiments", %{conn: conn} do
      conn = get(conn, Routes.experiment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Experiments"
    end
  end

  describe "new experiment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.experiment_path(conn, :new))
      assert html_response(conn, 200) =~ "New Experiment"
    end
  end

  describe "create experiment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.experiment_path(conn, :create), experiment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.experiment_path(conn, :show, id)

      conn = get(conn, Routes.experiment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Experiment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.experiment_path(conn, :create), experiment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Experiment"
    end
  end

  # describe "edit experiment" do
  #   setup [:create_ulc_experiment]

  #   test "renders form for editing chosen experiment", %{conn: conn, experiment: experiment} do
  #     conn = get(conn, Routes.experiment_path(conn, :edit, experiment))
  #     assert html_response(conn, 200) =~ "Edit Experiment"
  #   end
  # end

  # describe "update experiment" do
  #   setup [:create_ulc_experiment]

  #   test "redirects when data is valid", %{conn: conn, experiment: experiment} do
  #     conn =
  #       put(conn, Routes.experiment_path(conn, :update, experiment), experiment: @update_attrs)

  #     assert redirected_to(conn) == Routes.experiment_path(conn, :show, experiment)

  #     conn = get(conn, Routes.experiment_path(conn, :show, experiment))
  #     assert html_response(conn, 200) =~ "some updated author"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, experiment: experiment} do
  #     conn =
  #       put(conn, Routes.experiment_path(conn, :update, experiment), experiment: @invalid_attrs)

  #     assert html_response(conn, 200) =~ "Edit Experiment"
  #   end
  # end

  describe "delete experiment" do
    setup [:create_ulc_experiment]

    test "deletes chosen experiment", %{conn: conn, experiment: experiment} do
      conn = delete(conn, Routes.experiment_path(conn, :delete, experiment))
      assert redirected_to(conn) == Routes.experiment_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.experiment_path(conn, :show, experiment))
      end
    end
  end

  defp create_ulc_experiment(_) do
    experiment = ulc_experiment_fixture()
    %{experiment: experiment}
  end
end
