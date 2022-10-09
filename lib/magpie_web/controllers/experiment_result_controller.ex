defmodule MagpieWeb.ExperimentResultController do
  use MagpieWeb, :controller

  alias Magpie.Experiments
  alias Magpie.Experiments.ExperimentResult

  def create(conn, %{"experiment_result" => experiment_result_params}) do
    case Experiments.create_experiment_result(experiment_result_params) do
      {:ok, experiment_result} ->
        conn
        |> put_flash(:info, "Experiment result created successfully.")
        |> redirect(to: Routes.experiment_result_path(conn, :show, experiment_result))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
