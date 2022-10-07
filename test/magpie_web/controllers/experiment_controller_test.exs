defmodule MagpieWeb.ExperimentControllerTest do
  use MagpieWeb.ConnCase

  import Magpie.ExperimentsFixtures

  @create_attrs %{
    active: true,
    author: "some author",
    copy_count: 42,
    description: "some description",
    dynamic_retrieval_keys: [],
    expansion_strategy: :expansive,
    experiment_result_columns: [],
    is_ulc: true,
    name: "some name",
    slot_attempt_counts: %{},
    slot_dependencies: %{},
    slot_ordering: [],
    slot_statuses: %{},
    slot_trial_num_players: %{},
    ulc_num_chains: 42,
    ulc_num_generations: 42,
    ulc_num_players: 42,
    ulc_num_variants: 42
  }
  @update_attrs %{
    active: false,
    author: "some updated author",
    copy_count: 43,
    description: "some updated description",
    dynamic_retrieval_keys: [],
    expansion_strategy: :patient,
    experiment_result_columns: [],
    is_ulc: false,
    name: "some updated name",
    slot_attempt_counts: %{},
    slot_dependencies: %{},
    slot_ordering: [],
    slot_statuses: %{},
    slot_trial_num_players: %{},
    ulc_num_chains: 43,
    ulc_num_generations: 43,
    ulc_num_players: 43,
    ulc_num_variants: 43
  }
  @invalid_attrs %{
    active: nil,
    author: nil,
    copy_count: nil,
    description: nil,
    dynamic_retrieval_keys: nil,
    expansion_strategy: nil,
    experiment_result_columns: nil,
    is_ulc: nil,
    name: nil,
    slot_attempt_counts: nil,
    slot_dependencies: nil,
    slot_ordering: nil,
    slot_statuses: nil,
    slot_trial_num_players: nil,
    ulc_num_chains: nil,
    ulc_num_generations: nil,
    ulc_num_players: nil,
    ulc_num_variants: nil
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

  describe "edit experiment" do
    setup [:create_experiment]

    test "renders form for editing chosen experiment", %{conn: conn, experiment: experiment} do
      conn = get(conn, Routes.experiment_path(conn, :edit, experiment))
      assert html_response(conn, 200) =~ "Edit Experiment"
    end
  end

  describe "update experiment" do
    setup [:create_experiment]

    test "redirects when data is valid", %{conn: conn, experiment: experiment} do
      conn =
        put(conn, Routes.experiment_path(conn, :update, experiment), experiment: @update_attrs)

      assert redirected_to(conn) == Routes.experiment_path(conn, :show, experiment)

      conn = get(conn, Routes.experiment_path(conn, :show, experiment))
      assert html_response(conn, 200) =~ "some updated author"
    end

    test "renders errors when data is invalid", %{conn: conn, experiment: experiment} do
      conn =
        put(conn, Routes.experiment_path(conn, :update, experiment), experiment: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Experiment"
    end
  end

  describe "delete experiment" do
    setup [:create_experiment]

    test "deletes chosen experiment", %{conn: conn, experiment: experiment} do
      conn = delete(conn, Routes.experiment_path(conn, :delete, experiment))
      assert redirected_to(conn) == Routes.experiment_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.experiment_path(conn, :show, experiment))
      end
    end
  end

  defp create_experiment(_) do
    experiment = experiment_fixture()
    %{experiment: experiment}
  end
end
