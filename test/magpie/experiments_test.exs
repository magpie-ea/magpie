defmodule Magpie.ExperimentsTest do
  use Magpie.DataCase

  alias Magpie.Experiments

  describe "experiments" do
    alias Magpie.Experiments.Experiment

    import Magpie.ExperimentsFixtures

    test "list_experiments/0 returns all experiments" do
      experiment = ulc_experiment_fixture()
      assert Experiments.list_experiments() == [experiment]
    end

    test "get_experiment!/1 returns the experiment with given id" do
      experiment = ulc_experiment_fixture()
      assert Experiments.get_experiment!(experiment.id) == experiment
    end

    test "create_ulc_experiment/1 with valid data creates a experiment" do
      slot_ordering = [
        "1_1:1:1_1",
        "1_1:1:1_2",
        "1_1:1:2_1",
        "1_1:1:2_2",
        "1_1:2:1_1",
        "1_1:2:1_2",
        "1_1:2:2_1",
        "1_1:2:2_2",
        "1_2:1:1_1",
        "1_2:1:1_2",
        "1_2:1:2_1",
        "1_2:1:2_2",
        "1_2:2:1_1",
        "1_2:2:1_2",
        "1_2:2:2_1",
        "1_2:2:2_2"
      ]

      slot_statuses = %{
        "1_1:1:1_1" => "available",
        "1_1:1:1_2" => "available",
        "1_1:1:2_1" => "hold",
        "1_1:1:2_2" => "hold",
        "1_1:2:1_1" => "available",
        "1_1:2:1_2" => "available",
        "1_1:2:2_1" => "hold",
        "1_1:2:2_2" => "hold",
        "1_2:1:1_1" => "available",
        "1_2:1:1_2" => "available",
        "1_2:1:2_1" => "hold",
        "1_2:1:2_2" => "hold",
        "1_2:2:1_1" => "available",
        "1_2:2:1_2" => "available",
        "1_2:2:2_1" => "hold",
        "1_2:2:2_2" => "hold"
      }

      slot_trial_num_players = %{
        "1_1:1:1_1" => 2,
        "1_1:1:1_2" => 2,
        "1_1:1:2_1" => 2,
        "1_1:1:2_2" => 2,
        "1_1:2:1_1" => 2,
        "1_1:2:1_2" => 2,
        "1_1:2:2_1" => 2,
        "1_1:2:2_2" => 2,
        "1_2:1:1_1" => 2,
        "1_2:1:1_2" => 2,
        "1_2:1:2_1" => 2,
        "1_2:1:2_2" => 2,
        "1_2:2:1_1" => 2,
        "1_2:2:1_2" => 2,
        "1_2:2:2_1" => 2,
        "1_2:2:2_2" => 2
      }

      slot_dependencies = %{
        "1_1:1:1_1" => [],
        "1_1:1:1_2" => [],
        "1_1:1:2_1" => ["1_1:1:1_2", "1_1:1:1_1"],
        "1_1:1:2_2" => ["1_1:1:1_2", "1_1:1:1_1"],
        "1_1:2:1_1" => [],
        "1_1:2:1_2" => [],
        "1_1:2:2_1" => ["1_1:2:1_2", "1_1:2:1_1"],
        "1_1:2:2_2" => ["1_1:2:1_2", "1_1:2:1_1"],
        "1_2:1:1_1" => [],
        "1_2:1:1_2" => [],
        "1_2:1:2_1" => ["1_2:1:1_2", "1_2:1:1_1"],
        "1_2:1:2_2" => ["1_2:1:1_2", "1_2:1:1_1"],
        "1_2:2:1_1" => [],
        "1_2:2:1_2" => [],
        "1_2:2:2_1" => ["1_2:2:1_2", "1_2:2:1_1"],
        "1_2:2:2_2" => ["1_2:2:1_2", "1_2:2:1_1"]
      }

      slot_attempt_counts = %{
        "1_1:1:1_1" => 0,
        "1_1:1:1_2" => 0,
        "1_1:1:2_1" => 0,
        "1_1:1:2_2" => 0,
        "1_1:2:1_1" => 0,
        "1_1:2:1_2" => 0,
        "1_1:2:2_1" => 0,
        "1_1:2:2_2" => 0,
        "1_2:1:1_1" => 0,
        "1_2:1:1_2" => 0,
        "1_2:1:2_1" => 0,
        "1_2:1:2_2" => 0,
        "1_2:2:1_1" => 0,
        "1_2:2:1_2" => 0,
        "1_2:2:2_1" => 0,
        "1_2:2:2_2" => 0
      }

      valid_attrs = %{
        author: "some author",
        name: "some name",
        description: "some description",
        active: true,
        is_ulc: true,
        ulc_num_chains: 2,
        ulc_num_generations: 2,
        ulc_num_players: 2,
        ulc_num_variants: 2,
        expansion_strategy: :expansive
      }

      assert {:ok,
              %Experiment{
                slot_ordering: ^slot_ordering,
                slot_statuses: ^slot_statuses,
                slot_dependencies: ^slot_dependencies,
                slot_attempt_counts: ^slot_attempt_counts,
                slot_trial_num_players: ^slot_trial_num_players,
                copy_count: 1
              }} = Experiments.create_ulc_experiment(valid_attrs)
    end

    test "create_ulc_experiment/1 with invalid specification returns error changeset" do
      invalid_attrs = %{
        author: "some author",
        name: "some name",
        description: "some description",
        active: true,
        is_ulc: true,
        ulc_num_chains: -1,
        ulc_num_generations: 0,
        ulc_num_players: -100,
        ulc_num_variants: -50,
        expansion_strategy: :expansive
      }

      assert {:error, %Ecto.Changeset{}} = Experiments.create_ulc_experiment(invalid_attrs)
    end

    test "delete_experiment/1 deletes the experiment" do
      experiment = ulc_experiment_fixture()
      assert {:ok, %Experiment{}} = Experiments.delete_experiment(experiment)
      assert_raise Ecto.NoResultsError, fn -> Experiments.get_experiment!(experiment.id) end
    end
  end
end
