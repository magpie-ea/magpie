defmodule Magpie.Experiments.ExperimentResult do
  @doc """
  Stores the experiment results of one slot.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "experiment_results" do
    # Identifies a slot in this experiment.
    # Example: 1_1:1:1_1 for an ULC experiment.
    # {copy_count}_{chain}:{variant}:{generation}_{player}
    field :identifier, :string
    field :is_intermediate, :boolean, default: false
    field :results, {:array, :map}
    belongs_to(:experiment, Magpie.Experiments.Experiment)

    timestamps()
  end

  @doc false
  def changeset(experiment_result, attrs) do
    experiment_result
    |> cast(attrs, [:results, :is_intermediate, :identifier, :experiment_id])
    |> validate_required([:results, :identifier, :experiment_id])
  end
end
