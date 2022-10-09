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

  describe "experiment_results" do
    alias Magpie.Experiments.ExperimentResult

    import Magpie.ExperimentsFixtures

    @invalid_attrs %{identifier: nil, is_intermediate: nil, results: nil, experiment_id: nil}

    test "list_experiment_results/1 returns all experiment_results belonging to a particular experiment" do
      experiment = ulc_experiment_fixture()
      experiment_result_1 = experiment_result_fixture(experiment_id: experiment.id)
      experiment_result_2 = experiment_result_fixture(experiment_id: experiment.id)

      assert Experiments.list_experiment_results(experiment.id) == [
               experiment_result_1,
               experiment_result_2
             ]
    end

    test "get_experiment_result!/1 returns the experiment_result with given id" do
      experiment_result = experiment_result_fixture()
      assert Experiments.get_experiment_result!(experiment_result.id) == experiment_result
    end

    test "create_experiment_result/1 with valid data creates a experiment_result" do
      experiment = ulc_experiment_fixture()

      valid_attrs = %{
        experiment_id: experiment.id,
        identifier: "1_1:1:1_1",
        results: []
      }

      assert {:ok, %ExperimentResult{} = experiment_result} =
               Experiments.create_experiment_result(valid_attrs)

      assert experiment_result.identifier == "1_1:1:1_1"
      assert experiment_result.results == []
      assert experiment_result.experiment_id == experiment.id
    end

    test "create_experiment_result/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Experiments.create_experiment_result(@invalid_attrs)
    end

    test "update_experiment_result/2 with valid data updates the experiment_result" do
      experiment_result = experiment_result_fixture()
      update_attrs = %{identifier: "some updated identifier", is_intermediate: false, results: []}

      assert {:ok, %ExperimentResult{} = experiment_result} =
               Experiments.update_experiment_result(experiment_result, update_attrs)

      assert experiment_result.identifier == "some updated identifier"
      assert experiment_result.is_intermediate == false
      assert experiment_result.results == []
    end

    test "update_experiment_result/2 with invalid data returns error changeset" do
      experiment_result = experiment_result_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Experiments.update_experiment_result(experiment_result, @invalid_attrs)

      assert experiment_result == Experiments.get_experiment_result!(experiment_result.id)
    end

    test "delete_experiment_result/1 deletes the experiment_result" do
      experiment_result = experiment_result_fixture()
      assert {:ok, %ExperimentResult{}} = Experiments.delete_experiment_result(experiment_result)

      assert_raise Ecto.NoResultsError, fn ->
        Experiments.get_experiment_result!(experiment_result.id)
      end
    end

    test "change_experiment_result/1 returns a experiment_result changeset" do
      experiment_result = experiment_result_fixture()
      assert %Ecto.Changeset{} = Experiments.change_experiment_result(experiment_result)
    end
  end
end
