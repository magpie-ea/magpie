defmodule Magpie.Experiments.Slots do
  @moduledoc """
  Module for organizing logic related to slots in experiments.
  """
  alias Magpie.Experiments
  alias Magpie.Experiments.Experiment
  alias Magpie.Repo

  def produce_updated_slots_from_ulc_specification(%{
        ulc_num_variants: ulc_num_variants,
        ulc_num_chains: ulc_num_chains,
        ulc_num_generations: ulc_num_generations,
        ulc_num_players: ulc_num_players,
        slot_ordering: slot_ordering,
        slot_statuses: slot_statuses,
        slot_dependencies: slot_dependencies,
        slot_attempt_counts: slot_attempt_counts,
        slot_trial_num_players: slot_trial_num_players,
        copy_count: copy_count
      }) do
    # When we newly create the entries, we're always at the first copy of it all.
    updated_copy_count = copy_count + 1

    {updated_slot_ordering, updated_slot_statuses, updated_slot_dependencies,
     updated_slot_attempt_counts,
     updated_trial_players} =
      Enum.reduce(
        1..ulc_num_chains,
        {slot_ordering, slot_statuses, slot_dependencies, slot_attempt_counts,
         slot_trial_num_players},
        fn chain, acc ->
          Enum.reduce(1..ulc_num_variants, acc, fn variant, acc ->
            Enum.reduce(1..ulc_num_generations, acc, fn generation, acc ->
              Enum.reduce(1..ulc_num_players, acc, fn player,
                                                      {slot_ordering, slot_statuses,
                                                       slot_dependencies, slot_attempt_counts,
                                                       slot_trial_num_players} ->
                slot_name = "#{updated_copy_count}_#{chain}:#{variant}:#{generation}_#{player}"
                updated_slot_ordering = slot_ordering ++ [slot_name]
                updated_slot_statuses = Map.put(slot_statuses, slot_name, "hold")
                updated_slot_attempt_counts = Map.put(slot_attempt_counts, slot_name, 0)

                dependent_slots =
                  if generation > 1 do
                    Enum.reduce(1..ulc_num_players, [], fn cur_player, acc ->
                      dependency_slot_name =
                        "#{updated_copy_count}_#{chain}:#{variant}:#{generation - 1}_#{cur_player}"

                      [dependency_slot_name | acc]
                    end)
                  else
                    []
                  end

                updated_slot_dependencies = Map.put(slot_dependencies, slot_name, dependent_slots)

                updated_trial_players =
                  Map.put(slot_trial_num_players, slot_name, ulc_num_players)

                {updated_slot_ordering, updated_slot_statuses, updated_slot_dependencies,
                 updated_slot_attempt_counts, updated_trial_players}
              end)
            end)
          end)
        end
      )

    %{
      slot_ordering: updated_slot_ordering,
      slot_statuses: updated_slot_statuses,
      slot_dependencies: updated_slot_dependencies,
      slot_attempt_counts: updated_slot_attempt_counts,
      slot_trial_num_players: updated_trial_players,
      copy_count: updated_copy_count
    }
  end

  @doc """
  This function is called both when the experiment is first created, and when it runs out of slots and needs to be expanded.

  It will also try to free slots at the end of the action.
  """
  def initialize_or_update_slots_from_ulc_specification(%Experiment{} = experiment) do
    attrs = produce_updated_slots_from_ulc_specification(experiment)

    Experiments.update_experiment(experiment, attrs)
  end

  @doc """
  Get all slots that are free, in the order that's specificed in the :slot_ordering array.

  It does seem that the most natural place to perform "expand" would be within this function. We'd just need to make sure that we lock the table during the expansion.
  """

  # def get_all_available_slots(experiment_id) when is_integer(experiment_id) do
  #   experiment = Experiments.get_experiment!(experiment_id)
  #   get_all_available_slots(experiment)
  # end

  # def get_all_available_slots(
  #       %Experiment{
  #         slot_ordering: slot_ordering,
  #         slot_statuses: slot_statuses
  #       } = experiment
  #     ) do
  #   ordered_free_slots =
  #     Enum.filter(slot_ordering, fn slot_name ->
  #       Map.get(slot_statuses, slot_name) == "available"
  #     end)

  #   if Enum.empty?(ordered_free_slots) do
  #     {:ok, expanded_experiment} = expand_experiment(experiment)
  #     {:ok, expanded_experiment_with_freed_slots} = free_slots(expanded_experiment)
  #     get_all_available_slots(expanded_experiment_with_freed_slots)
  #   else
  #     ordered_free_slots
  #   end
  # end

  def set_slot_to_in_progress(experiment_id, slot_id) do
    Repo.transaction(fn ->
      %Experiment{
        slot_statuses: slot_statuses,
        slot_attempt_counts: slot_attempt_counts
      } = experiment = Experiments.get_experiment!(experiment_id)

      updated_statuses = Map.put(slot_statuses, slot_id, "in_progress")

      updated_attempt_counts =
        Map.update!(slot_attempt_counts, slot_id, fn previous_attempt_count ->
          previous_attempt_count + 1
        end)

      {:ok, experiment} =
        Experiments.update_experiment(experiment, %{
          slot_statuses: updated_statuses,
          slot_attempt_counts: updated_attempt_counts
        })

      experiment
    end)
  end

  defp expand_experiment(%Experiment{is_ulc: true} = experiment) do
    initialize_or_update_slots_from_ulc_specification(experiment)
  end

  @doc """
  Condition for freeing a slot:
  - This slot has condition "hold"
  - All dependencies of this slot has condition "done"

  Guess we'll need to go through all the slots for this check.

  Seems that the ordering might be irrelevant in this case.

  Note that this function only tries to free the slots. It doesn't perform the expansion.
  """
  def produce_updated_slot_statuses_via_free_slots(
        %{
          slot_statuses: orig_slot_statuses,
          slot_dependencies: _slot_dependencies
        } = experiment
      ) do
    # Do everything in one pass. Should be more efficient!
    # We don't have a use for freed_count now. Ignoring it for now.
    {new_slot_statuses, _freed_count} =
      Enum.reduce(orig_slot_statuses, {orig_slot_statuses, 0}, fn
        {slot_name, slot_status}, {orig_slot_statuses, freed_count} ->
          if slot_status == "hold" && all_dependencies_done?(slot_name, experiment) do
            {Map.put(orig_slot_statuses, slot_name, "available"), freed_count + 1}
          else
            {orig_slot_statuses, freed_count}
          end
      end)

    new_slot_statuses
  end

  defp all_dependencies_done?(slot_name, %{
         slot_statuses: slot_statuses,
         slot_dependencies: slot_dependencies
       }) do
    dependencies = Map.get(slot_dependencies, slot_name)
    Enum.all?(dependencies, fn dependency -> Map.get(slot_statuses, dependency) == "done" end)
  end

  # def update_slot_status(
  #       %Experiment{
  #         slot_ordering: _slot_ordering,
  #         slot_statuses: orig_slot_statuses,
  #         slot_dependencies: _slot_dependencies
  #       } = experiment,
  #       slot_name,
  #       new_slot_status
  #     ) do
  #   new_slot_statuses = Map.put(orig_slot_statuses, slot_name, new_slot_status)
  #   Experiments.update_experiment(experiment, slot_statuses: new_slot_statuses)
  # end

  def set_slot_as_complete(
        %Experiment{
          slot_statuses: slot_statuses
        } = experiment,
        slot_identifier
      ) do
    new_slot_statuses = Map.put(slot_statuses, slot_identifier, "complete")

    Experiments.update_experiment(experiment, %{slot_statuses: new_slot_statuses})
  end
end
