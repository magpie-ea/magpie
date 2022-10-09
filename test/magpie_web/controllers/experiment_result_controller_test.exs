defmodule MagpieWeb.ExperimentResultControllerTest do
  use MagpieWeb.ConnCase

  import Magpie.ExperimentsFixtures

  alias Magpie.Experiments.ExperimentResult

  @update_attrs %{
    identifier: "some updated identifier",
    is_intermediate: false,
    results: []
  }
  @invalid_attrs %{identifier: nil, is_intermediate: nil, results: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "index" do
  #   test "lists all experiment_results", %{conn: conn} do
  #     conn = get(conn, Routes.experiment_result_path(conn, :index))
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  describe "create experiment_result" do
    test "renders experiment_result when data is valid", %{conn: conn} do
      experiment = ulc_experiment_fixture()

      create_attrs = %{
        experiment_id: experiment.id,
        identifier: "1_1:1:1_1",
        results: []
      }

      conn =
        post(conn, Routes.experiment_result_path(conn, :create), experiment_result: create_attrs)

      assert response(conn, 201)

      # conn = get(conn, Routes.experiment_result_path(conn, :show, id))

      # assert %{
      #          "id" => ^id,
      #          "identifier" => "1_1:1:1_1",
      #          "is_intermediate" => true,
      #          "results" => []
      #        } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.experiment_result_path(conn, :create), experiment_result: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update experiment_result" do
  #   setup [:create_experiment_result]

  #   test "renders experiment_result when data is valid", %{conn: conn, experiment_result: %ExperimentResult{id: id} = experiment_result} do
  #     conn = put(conn, Routes.experiment_result_path(conn, :update, experiment_result), experiment_result: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.experiment_result_path(conn, :show, id))

  #     assert %{
  #              "id" => ^id,
  #              "identifier" => "some updated identifier",
  #              "is_intermediate" => false,
  #              "results" => []
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, experiment_result: experiment_result} do
  #     conn = put(conn, Routes.experiment_result_path(conn, :update, experiment_result), experiment_result: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete experiment_result" do
  #   setup [:create_experiment_result]

  #   test "deletes chosen experiment_result", %{conn: conn, experiment_result: experiment_result} do
  #     conn = delete(conn, Routes.experiment_result_path(conn, :delete, experiment_result))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.experiment_result_path(conn, :show, experiment_result))
  #     end
  #   end
  # end

  defp create_experiment_result(_) do
    experiment_result = experiment_result_fixture()
    %{experiment_result: experiment_result}
  end
end
