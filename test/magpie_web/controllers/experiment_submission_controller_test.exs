defmodule MagpieWeb.ExperimentSubmissionControllerTest do
  use MagpieWeb.ConnCase

  import Magpie.ExperimentsFixtures

  alias Magpie.Experiments.ExperimentSubmission

  @update_attrs %{
    identifier: "some updated identifier",
    is_intermediate: false,
    results: [
      %{
        "a" => 1,
        "b" => 2
      },
      %{
        "a" => 10,
        "b" => 11
      }
    ]
  }
  @invalid_attrs %{identifier: nil, is_intermediate: nil, results: nil, experiment_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "index" do
  #   test "lists all experiment_submissions", %{conn: conn} do
  #     conn = get(conn, Routes.experiment_submission_path(conn, :index))
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  describe "create experiment_submission" do
    test "renders experiment_submission when data is valid", %{conn: conn} do
      experiment = ulc_experiment_fixture()

      create_attrs = %{
        experiment_id: experiment.id,
        identifier: "1_1:1:1_1",
        results: []
      }

      conn =
        post(conn, Routes.experiment_submission_path(conn, :create),
          experiment_submission: create_attrs
        )

      assert response(conn, 201)

      # conn = get(conn, Routes.experiment_submission_path(conn, :show, id))

      # assert %{
      #          "id" => ^id,
      #          "identifier" => "1_1:1:1_1",
      #          "is_intermediate" => true,
      #          "results" => []
      #        } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.experiment_submission_path(conn, :create),
          experiment_submission: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update experiment_submission" do
  #   setup [:create_experiment_submission]

  #   test "renders experiment_submission when data is valid", %{conn: conn, experiment_submission: %ExperimentSubmission{id: id} = experiment_submission} do
  #     conn = put(conn, Routes.experiment_submission_path(conn, :update, experiment_submission), experiment_submission: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.experiment_submission_path(conn, :show, id))

  #     assert %{
  #              "id" => ^id,
  #              "identifier" => "some updated identifier",
  #              "is_intermediate" => false,
  #              "results" => []
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, experiment_submission: experiment_submission} do
  #     conn = put(conn, Routes.experiment_submission_path(conn, :update, experiment_submission), experiment_submission: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete experiment_submission" do
  #   setup [:create_experiment_submission]

  #   test "deletes chosen experiment_submission", %{conn: conn, experiment_submission: experiment_submission} do
  #     conn = delete(conn, Routes.experiment_submission_path(conn, :delete, experiment_submission))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.experiment_submission_path(conn, :show, experiment_submission))
  #     end
  #   end
  # end

  defp create_experiment_submission(_) do
    experiment_submission = experiment_submission_fixture()
    %{experiment_submission: experiment_submission}
  end
end
