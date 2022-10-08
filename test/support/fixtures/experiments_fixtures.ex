defmodule Magpie.ExperimentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Magpie.Experiments` context.
  """

  @doc """
  Generate a experiment.
  """
  def ulc_experiment_fixture(attrs \\ %{}) do
    {:ok, experiment} =
      attrs
      |> Enum.into(%{
        active: true,
        author: "some author",
        description: "some description",
        expansion_strategy: :expansive,
        is_ulc: true,
        name: "some name",
        ulc_num_chains: 2,
        ulc_num_generations: 2,
        ulc_num_players: 2,
        ulc_num_variants: 2
      })
      |> Magpie.Experiments.create_ulc_experiment()

    experiment
  end
end
