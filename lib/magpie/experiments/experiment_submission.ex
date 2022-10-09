defmodule Magpie.Experiments.ExperimentSubmission do
  @doc """
  Stores the experiment results of one slot.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "experiment_submissions" do
    # Identifies a slot in this experiment.
    # Example: 1_1:1:1_1 for an ULC experiment.
    # {copy_count}_{chain}:{variant}:{generation}_{player}
    field :slot_identifier, :string
    field :is_intermediate, :boolean, default: false
    field :results, {:array, :map}
    belongs_to(:experiment, Magpie.Experiments.Experiment)

    timestamps()
  end

  @doc false
  def changeset(experiment_submission, attrs) do
    experiment_submission
    |> cast(attrs, [:results, :is_intermediate, :slot_identifier, :experiment_id])
    |> validate_required([:results, :slot_identifier, :experiment_id])
    |> unique_constraint([:experiment_id, :slot_identifier])
    |> foreign_key_constraint(:experiment_id)
  end
end
