defmodule Magpie.Experiments.Experiment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "experiments" do
    field :active, :boolean, default: false
    field :author, :string
    field :copy_count, :integer
    field :description, :string
    field :dynamic_retrieval_keys, {:array, :string}
    field :expansion_strategy, Ecto.Enum, values: [:expansive, :patient, :no_expansion]
    field :experiment_result_columns, {:array, :string}
    field :is_ulc, :boolean, default: false
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
  def changeset(experiment, attrs) do
    experiment
    |> cast(attrs, [
      :name,
      :author,
      :description,
      :active,
      :dynamic_retrieval_keys,
      :experiment_result_columns,
      :is_ulc,
      :ulc_num_variants,
      :ulc_num_chains,
      :ulc_num_generations,
      :ulc_num_players,
      :copy_count,
      :slot_ordering,
      :slot_statuses,
      :slot_dependencies,
      :slot_attempt_counts,
      :slot_trial_num_players,
      :expansion_strategy
    ])
    |> validate_required([
      :name,
      :author,
      :active,
      :dynamic_retrieval_keys,
      :experiment_result_columns,
      :is_ulc,
      :copy_count,
      :slot_ordering,
      :slot_statuses,
      :slot_dependencies,
      :slot_attempt_counts,
      :slot_trial_num_players,
      :expansion_strategy
    ])
  end
end
