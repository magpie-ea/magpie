defmodule MagpieWeb.ExperimentSubmissionControllerTest do
  use MagpieWeb.ConnCase

  import Magpie.ExperimentsFixtures

  alias Magpie.Experiments.ExperimentSubmission

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create experiment_submission" do
    test "renders experiment_submission when data is valid", %{conn: conn} do
      experiment = ulc_experiment_fixture()

      create_attrs = %{
        "experiment_id" => experiment.id,
        "slot_identifier" => "1_1:1:1_1",
        "_json" => []
      }

      conn = post(conn, Routes.experiment_submission_path(conn, :create), create_attrs)

      experiment = Magpie.Repo.reload!(experiment)

      assert "done" == Map.get(experiment.slot_statuses, "1_1:1:1_1")

      assert response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{
        "experiment_id" => nil,
        "slot_identifier" => nil,
        "_json" => nil
      }

      conn = post(conn, Routes.experiment_submission_path(conn, :create), invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_experiment_submission(_) do
    experiment_submission = experiment_submission_fixture()
    %{experiment_submission: experiment_submission}
  end
end
