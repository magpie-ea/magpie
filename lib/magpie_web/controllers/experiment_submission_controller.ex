defmodule MagpieWeb.ExperimentSubmissionController do
  use MagpieWeb, :controller

  alias Magpie.Experiments
  alias Magpie.Experiments.ExperimentSubmission

  action_fallback MagpieWeb.FallbackController

  # def index(conn, _params) do
  #   experiment_submissions = Experiments.list_experiment_submissions()
  #   render(conn, "index.json", experiment_submissions: experiment_submissions)
  # end

  def create(conn, %{
        "experiment_id" => experiment_id,
        "identifier" => identifier,
        "_json" => results
      }) do
    params = %{
      "experiment_id" => experiment_id,
      "identifier" => identifier,
      "results" => results
    }

    with {:ok, %ExperimentSubmission{} = _experiment_submission} <-
           Experiments.create_experiment_submission(params) do
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(:created, "")
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

  # def show(conn, %{"id" => id}) do
  #   experiment_submission = Experiments.get_experiment_submission!(id)
  #   render(conn, "show.json", experiment_submission: experiment_submission)
  # end

  # def update(conn, %{"id" => id, "experiment_submission" => experiment_submission_params}) do
  #   experiment_submission = Experiments.get_experiment_submission!(id)

  #   with {:ok, %ExperimentSubmission{} = experiment_submission} <- Experiments.update_experiment_submission(experiment_submission, experiment_submission_params) do
  #     render(conn, "show.json", experiment_submission: experiment_submission)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   experiment_submission = Experiments.get_experiment_submission!(id)

  #   with {:ok, %ExperimentSubmission{}} <- Experiments.delete_experiment_submission(experiment_submission) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
