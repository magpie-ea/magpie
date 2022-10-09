defmodule MagpieWeb.ExperimentSubmissionController do
  use MagpieWeb, :controller

  alias Magpie.Experiments
  alias Magpie.Experiments.ExperimentSubmission

  action_fallback MagpieWeb.FallbackController

  def create(conn, %{
        "experiment_id" => experiment_id,
        "slot_identifier" => identifier,
        "_json" => results
      }) do
    params = %{
      "experiment_id" => experiment_id,
      "slot_identifier" => identifier,
      "results" => results
    }

    with {:ok, %ExperimentSubmission{} = _experiment_submission} <-
           Experiments.create_experiment_submission_and_mark_slot_as_done(params) do
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(:created, "Experiment submission succeeded.")
    end
  end

  def retrieve_as_csv(conn, %{"experiment_id" => experiment_id}) do
    case Experiments.retrieve_experiment_submissions_as_csv(experiment_id) do
      {:error, :no_submissions_yet} ->
        conn
        |> put_flash(:error, "No submissions for this experiment yet!")
        |> redirect(to: Routes.experiment_path(conn, :index))

      {:ok, file_path} ->
        download_name = "submissions_#{experiment_id}.csv"

        conn
        |> send_download({:file, file_path},
          content_type: "application/csv",
          filename: download_name
        )

      _ ->
        conn
        |> put_flash(:error, "Unknown error")
        |> redirect(to: Routes.experiment_path(conn, :index))
    end
  end
end
