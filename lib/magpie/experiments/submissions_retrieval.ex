defmodule Magpie.Experiments.SubmissionsRetrieval do
  @moduledoc """
  Module for logic related to retrieving experiment submissions.
  """
  alias Magpie.Experiments

  def retrieve_experiment_submissions_as_csv(experiment_id) do
    with [_result | _] = experiment_submissions <-
           Experiments.list_experiment_submissions(experiment_id),
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
    keys = ["submission_id" | ["slot_identifier" | keys]]

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
      {copy, identifier, player} = String.split(submission.slot_identifier, "_")
      # Inject the column "submission_id"
      trial =
        trial
        |> Map.put("submission_id", submission.id)
        |> Map.put("identifier", identifier)
        |> Map.put("copy", copy)
        |> Map.put("player", player)

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
end
