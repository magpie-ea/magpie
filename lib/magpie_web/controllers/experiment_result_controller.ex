defmodule MagpieWeb.ExperimentResultController do
  use MagpieWeb, :controller

  alias Magpie.Experiments
  alias Magpie.Experiments.ExperimentResult

  action_fallback MagpieWeb.FallbackController

  # def index(conn, _params) do
  #   experiment_results = Experiments.list_experiment_results()
  #   render(conn, "index.json", experiment_results: experiment_results)
  # end

  def create(conn, %{"experiment_result" => experiment_result_params}) do
    with {:ok, %ExperimentResult{} = _experiment_result} <-
           Experiments.create_experiment_result(experiment_result_params) do
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(:created, "")
    end
  end

  def retrieve_as_csv(conn, %{"experiment_id" => experiment_id}) do
    case Experiments.retrieve_experiment_results_as_csv(experiment_id) do
      {:error, :no_submissions_yet} ->
        conn
        |> put_flash(:error, "No submissions for this experiment yet!")
        |> redirect(to: Routes.experiment_path(conn, :index))

      {:ok, file_path} ->
        download_name = "results_#{experiment_id}.csv"

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
  #   experiment_result = Experiments.get_experiment_result!(id)
  #   render(conn, "show.json", experiment_result: experiment_result)
  # end

  # def update(conn, %{"id" => id, "experiment_result" => experiment_result_params}) do
  #   experiment_result = Experiments.get_experiment_result!(id)

  #   with {:ok, %ExperimentResult{} = experiment_result} <- Experiments.update_experiment_result(experiment_result, experiment_result_params) do
  #     render(conn, "show.json", experiment_result: experiment_result)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   experiment_result = Experiments.get_experiment_result!(id)

  #   with {:ok, %ExperimentResult{}} <- Experiments.delete_experiment_result(experiment_result) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
