defmodule MagpieWeb.ExperimentController do
  use MagpieWeb, :controller

  alias Magpie.Experiments
  alias Magpie.Experiments.Experiment

  def index(conn, _params) do
    experiments = Experiments.list_experiments()
    render(conn, "index.html", experiments: experiments)
  end

  def new(conn, _params) do
    changeset = Experiments.change_experiment(%Experiment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"experiment" => experiment_params}) do
    case Experiments.create_experiment(experiment_params) do
      {:ok, experiment} ->
        conn
        |> put_flash(:info, "Experiment created successfully.")
        |> redirect(to: Routes.experiment_path(conn, :show, experiment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    experiment = Experiments.get_experiment!(id)
    render(conn, "show.html", experiment: experiment)
  end

  def edit(conn, %{"id" => id}) do
    experiment = Experiments.get_experiment!(id)
    changeset = Experiments.change_experiment(experiment)
    render(conn, "edit.html", experiment: experiment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "experiment" => experiment_params}) do
    experiment = Experiments.get_experiment!(id)

    case Experiments.update_experiment(experiment, experiment_params) do
      {:ok, experiment} ->
        conn
        |> put_flash(:info, "Experiment updated successfully.")
        |> redirect(to: Routes.experiment_path(conn, :show, experiment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", experiment: experiment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    experiment = Experiments.get_experiment!(id)
    {:ok, _experiment} = Experiments.delete_experiment(experiment)

    conn
    |> put_flash(:info, "Experiment deleted successfully.")
    |> redirect(to: Routes.experiment_path(conn, :index))
  end
end
