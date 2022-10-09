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

  describe "experiment_submissions" do
    alias Magpie.Experiments.ExperimentSubmission

    import Magpie.ExperimentsFixtures

    @invalid_attrs %{identifier: nil, is_intermediate: nil, results: nil, experiment_id: nil}

    test "list_experiment_submissions/1 returns all experiment_submissions belonging to a particular experiment" do
      experiment = ulc_experiment_fixture()
      experiment_submission_1 = experiment_submission_fixture(experiment_id: experiment.id)
      experiment_submission_2 = experiment_submission_fixture(experiment_id: experiment.id)

      assert Experiments.list_experiment_submissions(experiment.id) == [
               experiment_submission_1,
               experiment_submission_2
             ]
    end

    test "get_experiment_submission!/1 returns the experiment_submission with given id" do
      experiment_submission = experiment_submission_fixture()

      assert Experiments.get_experiment_submission!(experiment_submission.id) ==
               experiment_submission
    end

    test "create_experiment_submission/1 with valid data creates a experiment_submission" do
      experiment = ulc_experiment_fixture()

      valid_attrs = %{
        experiment_id: experiment.id,
        identifier: "1_1:1:1_1",
        results: []
      }

      assert {:ok, %ExperimentSubmission{} = experiment_submission} =
               Experiments.create_experiment_submission(valid_attrs)

      assert experiment_submission.identifier == "1_1:1:1_1"
      assert experiment_submission.results == []
      assert experiment_submission.experiment_id == experiment.id
    end

    test "create_experiment_submission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Experiments.create_experiment_submission(@invalid_attrs)
    end

    test "update_experiment_submission/2 with valid data updates the experiment_submission" do
      experiment_submission = experiment_submission_fixture()
      update_attrs = %{identifier: "some updated identifier", is_intermediate: false, results: []}

      assert {:ok, %ExperimentSubmission{} = experiment_submission} =
               Experiments.update_experiment_submission(experiment_submission, update_attrs)

      assert experiment_submission.identifier == "some updated identifier"
      assert experiment_submission.is_intermediate == false
      assert experiment_submission.results == []
    end

    test "update_experiment_submission/2 with invalid data returns error changeset" do
      experiment_submission = experiment_submission_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Experiments.update_experiment_submission(experiment_submission, @invalid_attrs)

      assert experiment_submission ==
               Experiments.get_experiment_submission!(experiment_submission.id)
    end

    test "delete_experiment_submission/1 deletes the experiment_submission" do
      experiment_submission = experiment_submission_fixture()

      assert {:ok, %ExperimentSubmission{}} =
               Experiments.delete_experiment_submission(experiment_submission)

      assert_raise Ecto.NoResultsError, fn ->
        Experiments.get_experiment_submission!(experiment_submission.id)
      end
    end

    test "change_experiment_submission/1 returns a experiment_submission changeset" do
      experiment_submission = experiment_submission_fixture()
      assert %Ecto.Changeset{} = Experiments.change_experiment_submission(experiment_submission)
    end
  end
end
