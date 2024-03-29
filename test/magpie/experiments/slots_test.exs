defmodule Magpie.Experiments.SlotsTest do
  @moduledoc false
  use Magpie.DataCase

  alias Magpie.Experiments
  alias Magpie.Experiments.Experiment
  alias Magpie.Experiments.Slots

  alias Magpie.Repo

  import Magpie.ExperimentsFixtures

  #   describe "initialize_or_update_slots_from_ulc_specification/1" do
  #     test "correctly initializes slot specs for the given Experiment" do
  #       slot_ordering = [
  #         "1_1:1:1_1",
  #         "1_1:1:1_2",
  #         "1_1:1:2_1",
  #         "1_1:1:2_2",
  #         "1_1:2:1_1",
  #         "1_1:2:1_2",
  #         "1_1:2:2_1",
  #         "1_1:2:2_2",
  #         "1_2:1:1_1",
  #         "1_2:1:1_2",
  #         "1_2:1:2_1",
  #         "1_2:1:2_2",
  #         "1_2:2:1_1",
  #         "1_2:2:1_2",
  #         "1_2:2:2_1",
  #         "1_2:2:2_2"
  #       ]

  #       slot_statuses = %{
  #         "1_1:1:1_1" => "hold",
  #         "1_1:1:1_2" => "hold",
  #         "1_1:1:2_1" => "hold",
  #         "1_1:1:2_2" => "hold",
  #         "1_1:2:1_1" => "hold",
  #         "1_1:2:1_2" => "hold",
  #         "1_1:2:2_1" => "hold",
  #         "1_1:2:2_2" => "hold",
  #         "1_2:1:1_1" => "hold",
  #         "1_2:1:1_2" => "hold",
  #         "1_2:1:2_1" => "hold",
  #         "1_2:1:2_2" => "hold",
  #         "1_2:2:1_1" => "hold",
  #         "1_2:2:1_2" => "hold",
  #         "1_2:2:2_1" => "hold",
  #         "1_2:2:2_2" => "hold"
  #       }

  #       slot_trial_num_players = %{
  #         "1_1:1:1_1" => 2,
  #         "1_1:1:1_2" => 2,
  #         "1_1:1:2_1" => 2,
  #         "1_1:1:2_2" => 2,
  #         "1_1:2:1_1" => 2,
  #         "1_1:2:1_2" => 2,
  #         "1_1:2:2_1" => 2,
  #         "1_1:2:2_2" => 2,
  #         "1_2:1:1_1" => 2,
  #         "1_2:1:1_2" => 2,
  #         "1_2:1:2_1" => 2,
  #         "1_2:1:2_2" => 2,
  #         "1_2:2:1_1" => 2,
  #         "1_2:2:1_2" => 2,
  #         "1_2:2:2_1" => 2,
  #         "1_2:2:2_2" => 2
  #       }

  #       slot_dependencies = %{
  #         "1_1:1:1_1" => [],
  #         "1_1:1:1_2" => [],
  #         "1_1:1:2_1" => ["1_1:1:1_2", "1_1:1:1_1"],
  #         "1_1:1:2_2" => ["1_1:1:1_2", "1_1:1:1_1"],
  #         "1_1:2:1_1" => [],
  #         "1_1:2:1_2" => [],
  #         "1_1:2:2_1" => ["1_1:2:1_2", "1_1:2:1_1"],
  #         "1_1:2:2_2" => ["1_1:2:1_2", "1_1:2:1_1"],
  #         "1_2:1:1_1" => [],
  #         "1_2:1:1_2" => [],
  #         "1_2:1:2_1" => ["1_2:1:1_2", "1_2:1:1_1"],
  #         "1_2:1:2_2" => ["1_2:1:1_2", "1_2:1:1_1"],
  #         "1_2:2:1_1" => [],
  #         "1_2:2:1_2" => [],
  #         "1_2:2:2_1" => ["1_2:2:1_2", "1_2:2:1_1"],
  #         "1_2:2:2_2" => ["1_2:2:1_2", "1_2:2:1_1"]
  #       }

  #       slot_attempt_counts = %{
  #         "1_1:1:1_1" => 0,
  #         "1_1:1:1_2" => 0,
  #         "1_1:1:2_1" => 0,
  #         "1_1:1:2_2" => 0,
  #         "1_1:2:1_1" => 0,
  #         "1_1:2:1_2" => 0,
  #         "1_1:2:2_1" => 0,
  #         "1_1:2:2_2" => 0,
  #         "1_2:1:1_1" => 0,
  #         "1_2:1:1_2" => 0,
  #         "1_2:1:2_1" => 0,
  #         "1_2:1:2_2" => 0,
  #         "1_2:2:1_1" => 0,
  #         "1_2:2:1_2" => 0,
  #         "1_2:2:2_1" => 0,
  #         "1_2:2:2_2" => 0
  #       }

  #       {:ok, experiment} =
  #         Experiments.create_ulc_experiment(%{
  #           name: "some name",
  #           author: "some author",
  #           description: "some description",
  #           active: true,
  #           ulc_num_variants: 2,
  #           ulc_num_chains: 2,
  #           ulc_num_generations: 2,
  #           ulc_num_players: 2
  #         })

  #       assert {:ok,
  #               %Experiment{
  #                 slot_ordering: ^slot_ordering,
  #                 slot_statuses: ^slot_statuses,
  #                 slot_dependencies: ^slot_dependencies,
  #                 slot_attempt_counts: ^slot_attempt_counts,
  #                 slot_trial_num_players: ^slot_trial_num_players,
  #                 copy_count: 1
  #               }} = Slots.initialize_or_update_slots_from_ulc_specification(experiment)
  #     end

  #     test "expands the slots correctly for the given Experiment by incrementing the copy count" do
  #       starting_slot_ordering = [
  #         "1_1:1:1_1",
  #         "1_1:1:1_2",
  #         "1_1:1:2_1",
  #         "1_1:1:2_2",
  #         "1_1:2:1_1",
  #         "1_1:2:1_2",
  #         "1_1:2:2_1",
  #         "1_1:2:2_2",
  #         "1_2:1:1_1",
  #         "1_2:1:1_2",
  #         "1_2:1:2_1",
  #         "1_2:1:2_2",
  #         "1_2:2:1_1",
  #         "1_2:2:1_2",
  #         "1_2:2:2_1",
  #         "1_2:2:2_2"
  #       ]

  #       starting_slot_statuses = %{
  #         "1_1:1:1_1" => "done",
  #         "1_1:1:1_2" => "done",
  #         "1_1:1:2_1" => "done",
  #         "1_1:1:2_2" => "done",
  #         "1_1:2:1_1" => "done",
  #         "1_1:2:1_2" => "done",
  #         "1_1:2:2_1" => "done",
  #         "1_1:2:2_2" => "done",
  #         "1_2:1:1_1" => "done",
  #         "1_2:1:1_2" => "done",
  #         "1_2:1:2_1" => "done",
  #         "1_2:1:2_2" => "done",
  #         "1_2:2:1_1" => "done",
  #         "1_2:2:1_2" => "done",
  #         "1_2:2:2_1" => "done",
  #         "1_2:2:2_2" => "done"
  #       }

  #       starting_slot_dependencies = %{
  #         "1_1:1:1_1" => [],
  #         "1_1:1:1_2" => [],
  #         "1_1:1:2_1" => ["1_1:1:1_2", "1_1:1:1_1"],
  #         "1_1:1:2_2" => ["1_1:1:1_2", "1_1:1:1_1"],
  #         "1_1:2:1_1" => [],
  #         "1_1:2:1_2" => [],
  #         "1_1:2:2_1" => ["1_1:2:1_2", "1_1:2:1_1"],
  #         "1_1:2:2_2" => ["1_1:2:1_2", "1_1:2:1_1"],
  #         "1_2:1:1_1" => [],
  #         "1_2:1:1_2" => [],
  #         "1_2:1:2_1" => ["1_2:1:1_2", "1_2:1:1_1"],
  #         "1_2:1:2_2" => ["1_2:1:1_2", "1_2:1:1_1"],
  #         "1_2:2:1_1" => [],
  #         "1_2:2:1_2" => [],
  #         "1_2:2:2_1" => ["1_2:2:1_2", "1_2:2:1_1"],
  #         "1_2:2:2_2" => ["1_2:2:1_2", "1_2:2:1_1"]
  #       }

  #       starting_slot_attempt_counts = %{
  #         "1_1:1:1_1" => 1,
  #         "1_1:1:1_2" => 1,
  #         "1_1:1:2_1" => 1,
  #         "1_1:1:2_2" => 1,
  #         "1_1:2:1_1" => 1,
  #         "1_1:2:1_2" => 1,
  #         "1_1:2:2_1" => 1,
  #         "1_1:2:2_2" => 1,
  #         "1_2:1:1_1" => 1,
  #         "1_2:1:1_2" => 1,
  #         "1_2:1:2_1" => 1,
  #         "1_2:1:2_2" => 1,
  #         "1_2:2:1_1" => 1,
  #         "1_2:2:1_2" => 1,
  #         "1_2:2:2_1" => 1,
  #         "1_2:2:2_2" => 1
  #       }

  #       expected_slot_ordering = [
  #         "1_1:1:1_1",
  #         "1_1:1:1_2",
  #         "1_1:1:2_1",
  #         "1_1:1:2_2",
  #         "1_1:2:1_1",
  #         "1_1:2:1_2",
  #         "1_1:2:2_1",
  #         "1_1:2:2_2",
  #         "1_2:1:1_1",
  #         "1_2:1:1_2",
  #         "1_2:1:2_1",
  #         "1_2:1:2_2",
  #         "1_2:2:1_1",
  #         "1_2:2:1_2",
  #         "1_2:2:2_1",
  #         "1_2:2:2_2",
  #         "2_1:1:1_1",
  #         "2_1:1:1_2",
  #         "2_1:1:2_1",
  #         "2_1:1:2_2",
  #         "2_1:2:1_1",
  #         "2_1:2:1_2",
  #         "2_1:2:2_1",
  #         "2_1:2:2_2",
  #         "2_2:1:1_1",
  #         "2_2:1:1_2",
  #         "2_2:1:2_1",
  #         "2_2:1:2_2",
  #         "2_2:2:1_1",
  #         "2_2:2:1_2",
  #         "2_2:2:2_1",
  #         "2_2:2:2_2"
  #       ]

  #       expected_slot_statuses = %{
  #         "1_1:1:1_1" => "done",
  #         "1_1:1:1_2" => "done",
  #         "1_1:1:2_1" => "done",
  #         "1_1:1:2_2" => "done",
  #         "1_1:2:1_1" => "done",
  #         "1_1:2:1_2" => "done",
  #         "1_1:2:2_1" => "done",
  #         "1_1:2:2_2" => "done",
  #         "1_2:1:1_1" => "done",
  #         "1_2:1:1_2" => "done",
  #         "1_2:1:2_1" => "done",
  #         "1_2:1:2_2" => "done",
  #         "1_2:2:1_1" => "done",
  #         "1_2:2:1_2" => "done",
  #         "1_2:2:2_1" => "done",
  #         "1_2:2:2_2" => "done",
  #         "2_1:1:1_1" => "hold",
  #         "2_1:1:1_2" => "hold",
  #         "2_1:1:2_1" => "hold",
  #         "2_1:1:2_2" => "hold",
  #         "2_1:2:1_1" => "hold",
  #         "2_1:2:1_2" => "hold",
  #         "2_1:2:2_1" => "hold",
  #         "2_1:2:2_2" => "hold",
  #         "2_2:1:1_1" => "hold",
  #         "2_2:1:1_2" => "hold",
  #         "2_2:1:2_1" => "hold",
  #         "2_2:1:2_2" => "hold",
  #         "2_2:2:1_1" => "hold",
  #         "2_2:2:1_2" => "hold",
  #         "2_2:2:2_1" => "hold",
  #         "2_2:2:2_2" => "hold"
  #       }

  #       expected_slot_dependencies = %{
  #         "1_1:1:1_1" => [],
  #         "1_1:1:1_2" => [],
  #         "1_1:1:2_1" => ["1_1:1:1_2", "1_1:1:1_1"],
  #         "1_1:1:2_2" => ["1_1:1:1_2", "1_1:1:1_1"],
  #         "1_1:2:1_1" => [],
  #         "1_1:2:1_2" => [],
  #         "1_1:2:2_1" => ["1_1:2:1_2", "1_1:2:1_1"],
  #         "1_1:2:2_2" => ["1_1:2:1_2", "1_1:2:1_1"],
  #         "1_2:1:1_1" => [],
  #         "1_2:1:1_2" => [],
  #         "1_2:1:2_1" => ["1_2:1:1_2", "1_2:1:1_1"],
  #         "1_2:1:2_2" => ["1_2:1:1_2", "1_2:1:1_1"],
  #         "1_2:2:1_1" => [],
  #         "1_2:2:1_2" => [],
  #         "1_2:2:2_1" => ["1_2:2:1_2", "1_2:2:1_1"],
  #         "1_2:2:2_2" => ["1_2:2:1_2", "1_2:2:1_1"],
  #         "2_1:1:1_1" => [],
  #         "2_1:1:1_2" => [],
  #         "2_1:1:2_1" => ["2_1:1:1_2", "2_1:1:1_1"],
  #         "2_1:1:2_2" => ["2_1:1:1_2", "2_1:1:1_1"],
  #         "2_1:2:1_1" => [],
  #         "2_1:2:1_2" => [],
  #         "2_1:2:2_1" => ["2_1:2:1_2", "2_1:2:1_1"],
  #         "2_1:2:2_2" => ["2_1:2:1_2", "2_1:2:1_1"],
  #         "2_2:1:1_1" => [],
  #         "2_2:1:1_2" => [],
  #         "2_2:1:2_1" => ["2_2:1:1_2", "2_2:1:1_1"],
  #         "2_2:1:2_2" => ["2_2:1:1_2", "2_2:1:1_1"],
  #         "2_2:2:1_1" => [],
  #         "2_2:2:1_2" => [],
  #         "2_2:2:2_1" => ["2_2:2:1_2", "2_2:2:1_1"],
  #         "2_2:2:2_2" => ["2_2:2:1_2", "2_2:2:1_1"]
  #       }

  #       expected_slot_attempt_counts = %{
  #         "1_1:1:1_1" => 1,
  #         "1_1:1:1_2" => 1,
  #         "1_1:1:2_1" => 1,
  #         "1_1:1:2_2" => 1,
  #         "1_1:2:1_1" => 1,
  #         "1_1:2:1_2" => 1,
  #         "1_1:2:2_1" => 1,
  #         "1_1:2:2_2" => 1,
  #         "1_2:1:1_1" => 1,
  #         "1_2:1:1_2" => 1,
  #         "1_2:1:2_1" => 1,
  #         "1_2:1:2_2" => 1,
  #         "1_2:2:1_1" => 1,
  #         "1_2:2:1_2" => 1,
  #         "1_2:2:2_1" => 1,
  #         "1_2:2:2_2" => 1,
  #         "2_1:1:1_1" => 0,
  #         "2_1:1:1_2" => 0,
  #         "2_1:1:2_1" => 0,
  #         "2_1:1:2_2" => 0,
  #         "2_1:2:1_1" => 0,
  #         "2_1:2:1_2" => 0,
  #         "2_1:2:2_1" => 0,
  #         "2_1:2:2_2" => 0,
  #         "2_2:1:1_1" => 0,
  #         "2_2:1:1_2" => 0,
  #         "2_2:1:2_1" => 0,
  #         "2_2:1:2_2" => 0,
  #         "2_2:2:1_1" => 0,
  #         "2_2:2:1_2" => 0,
  #         "2_2:2:2_1" => 0,
  #         "2_2:2:2_2" => 0
  #       }

  #       {:ok, experiment} =
  #         Experiments.create_ulc_experiment(%{
  #           name: "some name",
  #           author: "some author",
  #           description: "some description",
  #           active: true,
  #           ulc_num_variants: 2,
  #           ulc_num_chains: 2,
  #           ulc_num_generations: 2,
  #           ulc_num_players: 2
  #         })

  #       {:ok, experiment} =
  #         Experiments.update_experiment(
  #           experiment,
  #           %{
  #             slot_statuses: starting_slot_statuses,
  #             slot_ordering: starting_slot_ordering,
  #             slot_dependencies: starting_slot_dependencies,
  #             slot_attempt_counts: starting_slot_attempt_counts,
  #             copy_count: 1
  #           }
  #         )

  #       {:ok, updated_experiment} =
  #         Slots.initialize_or_update_slots_from_ulc_specification(experiment)

  #       assert updated_experiment.slot_ordering == expected_slot_ordering
  #       assert updated_experiment.slot_statuses == expected_slot_statuses
  #       assert updated_experiment.slot_dependencies == expected_slot_dependencies
  #       assert updated_experiment.slot_attempt_counts == expected_slot_attempt_counts
  #     end
  #   end

  # describe "mark_slot_as_done_and_free_slots/2" do
  #   test "correctly marks slot as complete and frees newly free slots" do

  #   end
  # end

  describe "produce_updated_slot_statuses_via_free_slots/1" do
    test "correctly free slots from initial ULC state" do
      expected_slot_statuses = %{
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

      experiment = ulc_experiment_fixture()

      # 8 in total freed.
      # assert {{:ok, %Experiment{slot_statuses: ^expected_slot_statuses}}, 8} =
      assert expected_slot_statuses ==
               Slots.produce_updated_slot_statuses_via_free_slots(experiment)
    end

    test "correctly free slots based on slot_dependencies" do
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

      starting_slot_statuses = %{
        "1_1:1:1_1" => "done",
        "1_1:1:1_2" => "done",
        "1_1:1:2_1" => "hold",
        "1_1:1:2_2" => "hold",
        "1_1:2:1_1" => "done",
        "1_1:2:1_2" => "done",
        "1_1:2:2_1" => "hold",
        "1_1:2:2_2" => "hold",
        "1_2:1:1_1" => "done",
        "1_2:1:1_2" => "done",
        "1_2:1:2_1" => "hold",
        "1_2:1:2_2" => "hold",
        "1_2:2:1_1" => "done",
        "1_2:2:1_2" => "done",
        "1_2:2:2_1" => "hold",
        "1_2:2:2_2" => "hold"
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

      starting_slot_attempt_counts = %{
        "1_1:1:1_1" => 1,
        "1_1:1:1_2" => 1,
        "1_1:1:2_1" => 0,
        "1_1:1:2_2" => 0,
        "1_1:2:1_1" => 1,
        "1_1:2:1_2" => 1,
        "1_1:2:2_1" => 0,
        "1_1:2:2_2" => 0,
        "1_2:1:1_1" => 1,
        "1_2:1:1_2" => 1,
        "1_2:1:2_1" => 0,
        "1_2:1:2_2" => 0,
        "1_2:2:1_1" => 1,
        "1_2:2:1_2" => 1,
        "1_2:2:2_1" => 0,
        "1_2:2:2_2" => 0
      }

      expected_slot_statuses = %{
        "1_1:1:1_1" => "done",
        "1_1:1:1_2" => "done",
        "1_1:1:2_1" => "available",
        "1_1:1:2_2" => "available",
        "1_1:2:1_1" => "done",
        "1_1:2:1_2" => "done",
        "1_1:2:2_1" => "available",
        "1_1:2:2_2" => "available",
        "1_2:1:1_1" => "done",
        "1_2:1:1_2" => "done",
        "1_2:1:2_1" => "available",
        "1_2:1:2_2" => "available",
        "1_2:2:1_1" => "done",
        "1_2:2:1_2" => "done",
        "1_2:2:2_1" => "available",
        "1_2:2:2_2" => "available"
      }

      experiment = ulc_experiment_fixture()

      {:ok, experiment} =
        Experiments.update_experiment(
          experiment,
          %{
            slot_statuses: starting_slot_statuses,
            slot_ordering: slot_ordering,
            slot_dependencies: slot_dependencies,
            slot_attempt_counts: starting_slot_attempt_counts
          }
        )

      # 8 in total freed.
      # assert {{:ok, %Experiment{slot_statuses: ^expected_slot_statuses}}, 8} =
      assert expected_slot_statuses ==
               Slots.produce_updated_slot_statuses_via_free_slots(experiment)
    end
  end

  describe "free_slots_and_get_all_available_slots/1" do
    test "returns all available slots in the correct order" do
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

      starting_slot_statuses = %{
        "1_1:1:1_1" => "done",
        "1_1:1:1_2" => "done",
        "1_1:1:2_1" => "available",
        "1_1:1:2_2" => "available",
        "1_1:2:1_1" => "done",
        "1_1:2:1_2" => "done",
        "1_1:2:2_1" => "available",
        "1_1:2:2_2" => "available",
        "1_2:1:1_1" => "done",
        "1_2:1:1_2" => "done",
        "1_2:1:2_1" => "available",
        "1_2:1:2_2" => "available",
        "1_2:2:1_1" => "done",
        "1_2:2:1_2" => "done",
        "1_2:2:2_1" => "available",
        "1_2:2:2_2" => "available"
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

      starting_slot_attempt_counts = %{
        "1_1:1:1_1" => 1,
        "1_1:1:1_2" => 1,
        "1_1:1:2_1" => 0,
        "1_1:1:2_2" => 0,
        "1_1:2:1_1" => 1,
        "1_1:2:1_2" => 1,
        "1_1:2:2_1" => 0,
        "1_1:2:2_2" => 0,
        "1_2:1:1_1" => 1,
        "1_2:1:1_2" => 1,
        "1_2:1:2_1" => 0,
        "1_2:1:2_2" => 0,
        "1_2:2:1_1" => 1,
        "1_2:2:1_2" => 1,
        "1_2:2:2_1" => 0,
        "1_2:2:2_2" => 0
      }

      experiment = ulc_experiment_fixture()

      {:ok, experiment} =
        Experiments.update_experiment(
          experiment,
          %{
            slot_statuses: starting_slot_statuses,
            slot_ordering: slot_ordering,
            slot_dependencies: slot_dependencies,
            slot_attempt_counts: starting_slot_attempt_counts
          }
        )

      assert [
               "1_1:1:2_1",
               "1_1:1:2_2",
               "1_1:2:2_1",
               "1_1:2:2_2",
               "1_2:1:2_1",
               "1_2:1:2_2",
               "1_2:2:2_1",
               "1_2:2:2_2"
             ] == Slots.free_slots_and_get_all_available_slots(experiment)
    end

    test "expands the slots and frees them before returning the available ones, if there are no available slots" do
      starting_slot_ordering = [
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

      starting_slot_statuses = %{
        "1_1:1:1_1" => "done",
        "1_1:1:1_2" => "done",
        "1_1:1:2_1" => "done",
        "1_1:1:2_2" => "done",
        "1_1:2:1_1" => "done",
        "1_1:2:1_2" => "done",
        "1_1:2:2_1" => "done",
        "1_1:2:2_2" => "done",
        "1_2:1:1_1" => "done",
        "1_2:1:1_2" => "done",
        "1_2:1:2_1" => "done",
        "1_2:1:2_2" => "done",
        "1_2:2:1_1" => "done",
        "1_2:2:1_2" => "done",
        "1_2:2:2_1" => "done",
        "1_2:2:2_2" => "done"
      }

      starting_slot_dependencies = %{
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

      starting_slot_attempt_counts = %{
        "1_1:1:1_1" => 1,
        "1_1:1:1_2" => 1,
        "1_1:1:2_1" => 1,
        "1_1:1:2_2" => 1,
        "1_1:2:1_1" => 1,
        "1_1:2:1_2" => 1,
        "1_1:2:2_1" => 1,
        "1_1:2:2_2" => 1,
        "1_2:1:1_1" => 1,
        "1_2:1:1_2" => 1,
        "1_2:1:2_1" => 1,
        "1_2:1:2_2" => 1,
        "1_2:2:1_1" => 1,
        "1_2:2:1_2" => 1,
        "1_2:2:2_1" => 1,
        "1_2:2:2_2" => 1
      }

      experiment = ulc_experiment_fixture()

      {:ok, experiment} =
        Experiments.update_experiment(
          experiment,
          %{
            slot_statuses: starting_slot_statuses,
            slot_ordering: starting_slot_ordering,
            slot_dependencies: starting_slot_dependencies,
            slot_attempt_counts: starting_slot_attempt_counts,
            copy_count: 1
          }
        )

      assert [
               "2_1:1:1_1",
               "2_1:1:1_2",
               "2_1:2:1_1",
               "2_1:2:1_2",
               "2_2:1:1_1",
               "2_2:1:1_2",
               "2_2:2:1_1",
               "2_2:2:1_2"
             ] == Slots.free_slots_and_get_all_available_slots(experiment)
    end
  end

  describe "reset_status_for_inactive_slots" do
    test "resets status for slots without a heartbeat within the last 2 minutes to available" do
      starting_slot_statuses = %{
        "1_1:1:1_1" => "in_progress",
        "1_1:1:1_2" => "available",
        "1_1:1:2_1" => "available",
        "1_1:1:2_2" => "available",
        "1_1:2:1_1" => "available",
        "1_1:2:1_2" => "available",
        "1_1:2:2_1" => "available",
        "1_1:2:2_2" => "available",
        "1_2:1:1_1" => "available",
        "1_2:1:1_2" => "available",
        "1_2:1:2_1" => "available",
        "1_2:1:2_2" => "available",
        "1_2:2:1_1" => "available",
        "1_2:2:1_2" => "available",
        "1_2:2:2_1" => "available",
        "1_2:2:2_2" => "available"
      }

      expected_slot_statuses = %{
        "1_1:1:1_1" => "available",
        "1_1:1:1_2" => "available",
        "1_1:1:2_1" => "available",
        "1_1:1:2_2" => "available",
        "1_1:2:1_1" => "available",
        "1_1:2:1_2" => "available",
        "1_1:2:2_1" => "available",
        "1_1:2:2_2" => "available",
        "1_2:1:1_1" => "available",
        "1_2:1:1_2" => "available",
        "1_2:1:2_1" => "available",
        "1_2:1:2_2" => "available",
        "1_2:2:1_1" => "available",
        "1_2:2:1_2" => "available",
        "1_2:2:2_1" => "available",
        "1_2:2:2_2" => "available"
      }

      starting_slot_attempt_counts = %{
        "1_1:1:1_1" => 1,
        "1_1:1:1_2" => 1,
        "1_1:1:2_1" => 1,
        "1_1:1:2_2" => 1,
        "1_1:2:1_1" => 1,
        "1_1:2:1_2" => 1,
        "1_1:2:2_1" => 1,
        "1_1:2:2_2" => 1,
        "1_2:1:1_1" => 1,
        "1_2:1:1_2" => 1,
        "1_2:1:2_1" => 1,
        "1_2:1:2_2" => 1,
        "1_2:2:1_1" => 1,
        "1_2:2:1_2" => 1,
        "1_2:2:2_1" => 1,
        "1_2:2:2_2" => 1
      }

      expected_slot_attempt_counts = %{
        "1_1:1:1_1" => 2,
        "1_1:1:1_2" => 1,
        "1_1:1:2_1" => 1,
        "1_1:1:2_2" => 1,
        "1_1:2:1_1" => 1,
        "1_1:2:1_2" => 1,
        "1_1:2:2_1" => 1,
        "1_1:2:2_2" => 1,
        "1_2:1:1_1" => 1,
        "1_2:1:1_2" => 1,
        "1_2:1:2_1" => 1,
        "1_2:1:2_2" => 1,
        "1_2:2:1_1" => 1,
        "1_2:2:1_2" => 1,
        "1_2:2:2_1" => 1,
        "1_2:2:2_2" => 1
      }

      starting_slot_heartbeats = %{
        "1_1:1:1_1" => 0
      }

      expected_slot_heartbeats = %{
        "1_1:1:1_1" => nil
      }

      experiment = ulc_experiment_fixture()

      Experiments.update_experiment(
        experiment,
        %{
          slot_statuses: starting_slot_statuses,
          slot_attempt_counts: starting_slot_attempt_counts,
          slot_heartbeats: expected_slot_heartbeats
        }
      )

      Slots.reset_status_for_inactive_slots()

      experiment = Repo.reload(experiment)

      assert experiment.slot_attempt_counts == expected_slot_attempt_counts
      assert experiment.slot_statuses == expected_slot_statuses
      assert experiment.slot_heartbeats == expected_slot_heartbeats
    end
  end

  describe "report_heartbeat/2" do
    test "updates the heartbeat map accordingly" do
      experiment = ulc_experiment_fixture()

      Slots.report_heartbeat(experiment.id, "1_1:1:1_1")

      experiment = Repo.reload(experiment)

      assert %{"1_1:1:1_1" => _} = experiment.slot_heartbeats
    end
  end
end
