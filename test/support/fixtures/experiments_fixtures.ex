defmodule Magpie.ExperimentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Magpie.Experiments` context.
  """

  @doc """
  Generate a experiment.
  """
  def experiment_fixture(attrs \\ %{}) do
    {:ok, experiment} =
      attrs
      |> Enum.into(%{
        active: true,
        author: "some author",
        copy_count: 42,
        description: "some description",
        dynamic_retrieval_keys: [],
        expansion_strategy: :expansive,
        experiment_result_columns: [],
        is_ulc: true,
        name: "some name",
        slot_attempt_counts: %{},
        slot_dependencies: %{},
        slot_ordering: [],
        slot_statuses: %{},
        slot_trial_num_players: %{},
        ulc_num_chains: 42,
        ulc_num_generations: 42,
        ulc_num_players: 42,
        ulc_num_variants: 42
      })
      |> Magpie.Experiments.create_ulc_experiment()

    experiment
  end
end
