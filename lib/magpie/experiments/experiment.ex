defmodule Magpie.Experiments.Experiment do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Magpie.Experiments.Slots

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "experiments" do
    field :active, :boolean, default: true
    field :author, :string
    field :copy_count, :integer
    field :description, :string
    field :dynamic_retrieval_keys, {:array, :string}
    field :expansion_strategy, Ecto.Enum, values: [:expansive, :patient, :no_expansion]
    field :experiment_result_columns, {:array, :string}
    field :is_ulc, :boolean, default: true
    field :name, :string
    field :slot_attempt_counts, :map
    field :slot_dependencies, :map
    field :slot_ordering, {:array, :string}
    field :slot_statuses, :map
    field :slot_trial_num_players, :map
    field :ulc_num_chains, :integer
    field :ulc_num_generations, :integer
    field :ulc_num_players, :integer
    field :ulc_num_variants, :integer

    timestamps()
  end

  @doc false
  def create_changeset_ulc(experiment, attrs \\ %{}) do
    experiment
    |> cast(attrs, [
      :name,
      :author,
      :description,
      :active,
      :dynamic_retrieval_keys,
      :is_ulc,
      :ulc_num_variants,
      :ulc_num_chains,
      :ulc_num_generations,
      :ulc_num_players,
      :expansion_strategy
    ])
    |> validate_required([
      :name,
      :author,
      :active,
      :is_ulc,
      :expansion_strategy
    ])
    |> validate_ulc_experiment_requirements()
    |> initialize_slot_fields()
  end

  # Not enabling updates in this version yet.
  # def update_changeset(experiment, attrs \\ %{}) do
  #   experiment
  #   |> cast(attrs, [
  #     :name,
  #     :author,
  #     :description,
  #     :active,
  #     :dynamic_retrieval_keys,
  #     :experiment_result_columns,
  #     :slot_ordering,
  #     :slot_statuses,
  #     :slot_dependencies,
  #     :slot_attempt_counts,
  #     :slot_trial_num_players,
  #     :copy_count,
  #     :expansion_strategy
  #   ])
  #   |> validate_required([
  #     :name,
  #     :author,
  #     :active,
  #     :is_ulc,
  #     :expansion_strategy
  #   ])
  # end

  defp validate_ulc_experiment_requirements(changeset) do
    changeset
    |> validate_required([
      :ulc_num_variants,
      :ulc_num_chains,
      :ulc_num_generations,
      :ulc_num_players
    ])
    |> validate_number(:ulc_num_variants, greater_than: 0)
    |> validate_number(:ulc_num_chains, greater_than: 0)
    |> validate_number(:ulc_num_generations, greater_than: 0)
    |> validate_number(:ulc_num_players, greater_than: 0)
  end

  # During the initialization, we first create the correct specifications, then perform the `free` operation on the slots.
  defp initialize_slot_fields(%{valid?: true} = changeset) do
    %{
      slot_ordering: updated_slot_ordering,
      slot_statuses: updated_slot_statuses,
      slot_dependencies: updated_slot_dependencies,
      slot_attempt_counts: updated_slot_attempt_counts,
      slot_trial_num_players: updated_trial_players,
      copy_count: updated_copy_count
    } =
      Slots.produce_updated_slots_from_ulc_specification(%{
        ulc_num_variants: get_field(changeset, :ulc_num_variants),
        ulc_num_chains: get_field(changeset, :ulc_num_chains),
        ulc_num_generations: get_field(changeset, :ulc_num_generations),
        ulc_num_players: get_field(changeset, :ulc_num_players),
        slot_ordering: [],
        slot_statuses: %{},
        slot_dependencies: %{},
        slot_attempt_counts: %{},
        slot_trial_num_players: %{},
        copy_count: 0
      })

    freed_slot_statuses =
      Slots.produce_updated_slot_statuses_via_free_slots(%{
        slot_statuses: updated_slot_statuses,
        slot_dependencies: updated_slot_dependencies
      })

    changeset
    |> put_change(:slot_ordering, updated_slot_ordering)
    |> put_change(:slot_statuses, freed_slot_statuses)
    |> put_change(:slot_dependencies, updated_slot_dependencies)
    |> put_change(:slot_attempt_counts, updated_slot_attempt_counts)
    |> put_change(:slot_trial_num_players, updated_trial_players)
    |> put_change(:copy_count, updated_copy_count)
  end

  # In the previous step we should have checked whether the given values are valid or not.
  defp initialize_slot_fields(%{valid?: false} = changeset) do
    changeset
  end
end
