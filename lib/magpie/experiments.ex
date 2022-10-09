defmodule Magpie.Experiments do
  @moduledoc """
  The Experiments context.
  """

  import Ecto.Query, warn: false
  alias Magpie.Repo

  alias Magpie.Experiments.Experiment
  alias Magpie.Experiments.ExperimentSubmission
  alias Magpie.Experiments.SubmissionsRetrieval

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
  Return all the experiment results belonging to a particular experiment.
  """
  def list_experiment_submissions(experiment_id) do
    Repo.all(from ep in ExperimentSubmission, where: ep.experiment_id == ^experiment_id)
  end

  defdelegate retrieve_experiment_submissions_as_csv(experiment_id),
    to: SubmissionsRetrieval

  @doc """
  Gets a single experiment_submission.

  Raises `Ecto.NoResultsError` if the Experiment result does not exist.

  ## Examples

      iex> get_experiment_submission!(123)
      %ExperimentSubmission{}

      iex> get_experiment_submission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_experiment_submission!(id), do: Repo.get!(ExperimentSubmission, id)

  @doc """
  Creates a experiment_submission.

  ## Examples

      iex> create_experiment_submission(%{field: value})
      {:ok, %ExperimentSubmission{}}

      iex> create_experiment_submission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_experiment_submission(attrs) do
    %ExperimentSubmission{}
    |> ExperimentSubmission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a experiment_submission.

  ## Examples

      iex> update_experiment_submission(experiment_submission, %{field: new_value})
      {:ok, %ExperimentSubmission{}}

      iex> update_experiment_submission(experiment_submission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_experiment_submission(%ExperimentSubmission{} = experiment_submission, attrs) do
    experiment_submission
    |> ExperimentSubmission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a experiment_submission.

  ## Examples

      iex> delete_experiment_submission(experiment_submission)
      {:ok, %ExperimentSubmission{}}

      iex> delete_experiment_submission(experiment_submission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experiment_submission(%ExperimentSubmission{} = experiment_submission) do
    Repo.delete(experiment_submission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking experiment_submission changes.

  ## Examples

      iex> change_experiment_submission(experiment_submission)
      %Ecto.Changeset{data: %ExperimentSubmission{}}

  """
  def change_experiment_submission(%ExperimentSubmission{} = experiment_submission, attrs \\ %{}) do
    ExperimentSubmission.changeset(experiment_submission, attrs)
  end
end
