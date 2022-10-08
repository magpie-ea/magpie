defmodule Magpie.ExperimentsTest do
  use Magpie.DataCase

  alias Magpie.Experiments

  describe "experiments" do
    alias Magpie.Experiments.Experiment

    import Magpie.ExperimentsFixtures

    @invalid_attrs %{
      active: nil,
      author: nil,
      copy_count: nil,
      description: nil,
      dynamic_retrieval_keys: nil,
      expansion_strategy: nil,
      experiment_result_columns: nil,
      is_ulc: nil,
      name: nil,
      slot_attempt_counts: nil,
      slot_dependencies: nil,
      slot_ordering: nil,
      slot_statuses: nil,
      slot_trial_num_players: nil,
      ulc_num_chains: nil,
      ulc_num_generations: nil,
      ulc_num_players: nil,
      ulc_num_variants: nil
    }

    test "list_experiments/0 returns all experiments" do
      experiment = experiment_fixture()
      assert Experiments.list_experiments() == [experiment]
    end

    test "get_experiment!/1 returns the experiment with given id" do
      experiment = experiment_fixture()
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
        dynamic_retrieval_keys: [],
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

    test "create_ulc_experiment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Experiments.create_ulc_experiment(@invalid_attrs)
    end

    test "update_experiment/2 with valid data updates the experiment" do
      experiment = experiment_fixture()

      update_attrs = %{
        active: false,
        author: "some updated author",
        copy_count: 43,
        description: "some updated description",
        dynamic_retrieval_keys: [],
        expansion_strategy: :patient,
        experiment_result_columns: [],
        is_ulc: false,
        name: "some updated name",
        slot_attempt_counts: %{},
        slot_dependencies: %{},
        slot_ordering: [],
        slot_statuses: %{},
        slot_trial_num_players: %{},
        ulc_num_chains: 43,
        ulc_num_generations: 43,
        ulc_num_players: 43,
        ulc_num_variants: 43
      }

      assert {:ok, %Experiment{} = experiment} =
               Experiments.update_experiment(experiment, update_attrs)

      assert experiment.active == false
      assert experiment.author == "some updated author"
      assert experiment.copy_count == 43
      assert experiment.description == "some updated description"
      assert experiment.dynamic_retrieval_keys == []
      assert experiment.expansion_strategy == :patient
      assert experiment.experiment_result_columns == []
      assert experiment.is_ulc == false
      assert experiment.name == "some updated name"
      assert experiment.slot_attempt_counts == %{}
      assert experiment.slot_dependencies == %{}
      assert experiment.slot_ordering == []
      assert experiment.slot_statuses == %{}
      assert experiment.slot_trial_num_players == %{}
      assert experiment.ulc_num_chains == 43
      assert experiment.ulc_num_generations == 43
      assert experiment.ulc_num_players == 43
      assert experiment.ulc_num_variants == 43
    end

    test "update_experiment/2 with invalid data returns error changeset" do
      experiment = experiment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Experiments.update_experiment(experiment, @invalid_attrs)

      assert experiment == Experiments.get_experiment!(experiment.id)
    end

    test "delete_experiment/1 deletes the experiment" do
      experiment = experiment_fixture()
      assert {:ok, %Experiment{}} = Experiments.delete_experiment(experiment)
      assert_raise Ecto.NoResultsError, fn -> Experiments.get_experiment!(experiment.id) end
    end

    test "change_experiment/1 returns a experiment changeset" do
      experiment = experiment_fixture()
      assert %Ecto.Changeset{} = Experiments.change_experiment(experiment)
    end
  end
end
