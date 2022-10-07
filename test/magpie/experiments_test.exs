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

    test "create_experiment/1 with valid data creates a experiment" do
      valid_attrs = %{
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
      }

      assert {:ok, %Experiment{} = experiment} = Experiments.create_experiment(valid_attrs)
      assert experiment.active == true
      assert experiment.author == "some author"
      assert experiment.copy_count == 42
      assert experiment.description == "some description"
      assert experiment.dynamic_retrieval_keys == []
      assert experiment.expansion_strategy == :expansive
      assert experiment.experiment_result_columns == []
      assert experiment.is_ulc == true
      assert experiment.name == "some name"
      assert experiment.slot_attempt_counts == %{}
      assert experiment.slot_dependencies == %{}
      assert experiment.slot_ordering == []
      assert experiment.slot_statuses == %{}
      assert experiment.slot_trial_num_players == %{}
      assert experiment.ulc_num_chains == 42
      assert experiment.ulc_num_generations == 42
      assert experiment.ulc_num_players == 42
      assert experiment.ulc_num_variants == 42
    end

    test "create_experiment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Experiments.create_experiment(@invalid_attrs)
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
