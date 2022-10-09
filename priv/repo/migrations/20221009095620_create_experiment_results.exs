defmodule Magpie.Repo.Migrations.CreateExperimentResults do
  use Ecto.Migration

  def change do
    create table(:experiment_results, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :results, {:array, :map}, null: false
      add :is_intermediate, :boolean, default: false
      add :identifier, :string, null: false
      add :experiment_id, references(:experiments, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:experiment_results, [:experiment_id])
  end
end
