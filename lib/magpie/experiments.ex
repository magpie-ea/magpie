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
  def create_ulc_experiment(attrs \\ %{}) do
    %Experiment{}
    |> Experiment.create_changeset_ulc(attrs)
    |> Repo.insert()
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
  def create_experiment_result(attrs \\ %{}) do
    %ExperimentResult{}
    |> ExperimentResult.changeset(attrs)
    |> Repo.insert()
  end

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
