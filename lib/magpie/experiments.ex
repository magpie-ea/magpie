defmodule Magpie.Experiments do
  @moduledoc """
  The Experiments context.
  """

  import Ecto.Query, warn: false
  alias Magpie.Repo

  alias Magpie.Experiments.Experiment
  alias Magpie.Experiments.ExperimentSubmission

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

  def retrieve_experiment_submissions_as_csv(experiment_id) do
    with [_result | _] = experiment_submissions <-
           list_experiment_submissions(experiment_id),
         {:ok, file_path} <- Briefly.create(),
         file <- File.open!(file_path, [:write, :utf8]),
         [_key | _] = keys <-
           get_keys_from_all_results(experiment_submissions) do
      prepare_submissions_for_csv_download(keys, experiment_submissions)
      # Enum.each because the CSV library returns a stream, with each row being an entry. We need to make the stream concrete with this step.
      |> Enum.each(&IO.write(file, &1))

      File.close(file)

      {:ok, file_path}
    else
      [] -> {:error, :no_submissions_yet}
      error -> error
    end
  end

  defp get_keys_from_all_results(results) do
    keys =
      Enum.reduce(results, MapSet.new(), fn result, keys ->
        results = result.results

        case results do
          [trial | _] -> MapSet.union(MapSet.new(Map.keys(trial)), keys)
          _ -> keys
        end
      end)

    MapSet.to_list(keys)
  end

  # Writes the submissions to a CSV file.
  # Note that we have a validation in schemas to ensure that each entry in `results` must have the same set of keys. So the following code take take that as an assumption.
  defp prepare_submissions_for_csv_download([_key | _] = keys, submissions) do
    # We need to prepend an additional column which contains uid in the output
    keys = ["submission_id" | keys]

    # The list `outputs` contains all rows of the resulting CSV file.
    # The first row will be the keys, i.e. headers
    outputs = [keys]

    # For each submission, get the results and concatenate it to the `outputs` list.
    outputs =
      outputs ++
        List.foldl(submissions, [], fn submission, acc ->
          acc ++ format_submission(submission, keys)
        end)

    # Note that the separator defaults to \r\n just to be safe
    outputs |> CSV.encode()
  end

  defp prepare_submissions_for_csv_download(_, _submissions) do
    []
  end

  # For each trial recorded in this one experimentresult, ensure the proper key order is used to extract values.
  defp format_submission(submission, keys) do
    # Essentially this is just reordering.
    Enum.map(submission.results, fn trial ->
      # Inject the column "submission_id"
      trial = Map.put(trial, "submission_id", submission.id)
      # For each trial, use the order specified by keys
      keys
      # This is processing done when one of fields is an array. Though this type of submission should be discouraged.
      |> Enum.map(fn k -> format_value(Map.get(trial, k, "")) end)
    end)
  end

  # This special processing has always been there and let's keep it this way.
  defp format_value(value) when is_list(value) do
    Enum.join(value, "|")
  end

  defp format_value(value) do
    case String.Chars.impl_for(value) do
      # e.g. maps. Then we just return it as it is.
      nil ->
        Kernel.inspect(value)

      _ ->
        to_string(value)
    end
  end

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
