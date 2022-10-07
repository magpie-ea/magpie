defmodule Magpie.Repo.Migrations.CreateExperiments do
  use Ecto.Migration

  def change do
    create table(:experiments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :author, :string, null: false
      add :description, :string
      add :active, :boolean, default: true, null: false
      add :dynamic_retrieval_keys, {:array, :string}
      add :experiment_result_columns, {:array, :string}
      add :is_ulc, :boolean, default: false, null: false
      add :ulc_num_variants, :integer
      add :ulc_num_chains, :integer
      add :ulc_num_generations, :integer
      add :ulc_num_players, :integer
      add :copy_count, :integer, null: false, default: 0
      add :slot_ordering, {:array, :string}, null: false
      add :slot_statuses, :map, null: false
      add :slot_dependencies, :map, null: false
      add :slot_attempt_counts, :map, null: false
      add :slot_trial_num_players, :map, null: false
      add :expansion_strategy, :string

      timestamps()
    end
  end
end
