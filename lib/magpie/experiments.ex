defmodule Magpie.Experiments do
  @moduledoc """
  The Experiments context.
  """

  import Ecto.Query, warn: false
  alias Magpie.Repo

  alias Magpie.Experiments.Experiment
  alias Magpie.Experiments.ExperimentResult

  @doc """
  Returns the list of experiments.

  ## Examples

      iex> list_experiments()
      [%Experiment{}, ...]

  """
  def list_experiments do
    Repo.all(Experiment)
  end

  @doc """
  Gets a single experiment.

  Raises `Ecto.NoResultsError` if the Experiment does not exist.

  ## Examples

      iex> get_experiment!(123)
      %Experiment{}

      iex> get_experiment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_experiment!(id), do: Repo.get!(Experiment, id)

  @doc """
  Creates a experiment.

  ## Examples

      iex> create_ulc_experiment(%{field: value})
      {:ok, %Experiment{}}

      iex> create_ulc_experiment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ulc_experiment(attrs) do
    %Experiment{}
    |> Experiment.create_changeset_ulc(attrs)
    |> Repo.insert()
  end

  def update_experiment(%Experiment{} = experiment, attrs) do
    experiment
    |> Experiment.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a experiment.

  ## Examples

      iex> delete_experiment(experiment)
      {:ok, %Experiment{}}

      iex> delete_experiment(experiment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experiment(%Experiment{} = experiment) do
    Repo.delete(experiment)
  end

  @doc """
  Gets a single experiment_result.

  Raises `Ecto.NoResultsError` if the Experiment result does not exist.

  ## Examples

      iex> get_experiment_result!(123)
      %ExperimentResult{}

      iex> get_experiment_result!(456)
      ** (Ecto.NoResultsError)

  """
  def get_experiment_result!(id), do: Repo.get!(ExperimentResult, id)

  @doc """
  Creates a experiment_result.

  ## Examples

      iex> create_experiment_result(%{field: value})
      {:ok, %ExperimentResult{}}

      iex> create_experiment_result(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_experiment_result(attrs) do
    %ExperimentResult{}
    |> ExperimentResult.changeset(attrs)
    |> Repo.insert()
  end

  # To be honest this feels unnecessary at this point. Let's just not do it for now.
  # defp update_experiment_result_columns(experiment, results) do
  #   # previously_accumulated_columns <- experiment.
  #   with [trial | _] <- results,
  #        keys <- Map.keys(trial),
  #        previously_accumulated_columns <-
  #          Map.get(experiment, :experiment_result_columns) || [],
  #        new_experiment_result_columns <- merge_columns(keys, previously_accumulated_columns) do
  #     update_experiment(experiment, %{experiment_result_columns: new_experiment_result_columns})
  #   else
  #     [] -> {:error, :unprocessable_entity}
  #     error -> error
  #   end
  # end

  # defp merge_columns(keys, previously_accumulated_columns) do
  #   merged_columns = MapSet.union(MapSet.new(keys), MapSet.new(previously_accumulated_columns))
  #   MapSet.to_list(merged_columns)
  # end

  @doc """
  Updates a experiment_result.

  ## Examples

      iex> update_experiment_result(experiment_result, %{field: new_value})
      {:ok, %ExperimentResult{}}

      iex> update_experiment_result(experiment_result, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_experiment_result(%ExperimentResult{} = experiment_result, attrs) do
    experiment_result
    |> ExperimentResult.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a experiment_result.

  ## Examples

      iex> delete_experiment_result(experiment_result)
      {:ok, %ExperimentResult{}}

      iex> delete_experiment_result(experiment_result)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experiment_result(%ExperimentResult{} = experiment_result) do
    Repo.delete(experiment_result)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking experiment_result changes.

  ## Examples

      iex> change_experiment_result(experiment_result)
      %Ecto.Changeset{data: %ExperimentResult{}}

  """
  def change_experiment_result(%ExperimentResult{} = experiment_result, attrs \\ %{}) do
    ExperimentResult.changeset(experiment_result, attrs)
  end
end
