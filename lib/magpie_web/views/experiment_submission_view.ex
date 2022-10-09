defmodule MagpieWeb.ExperimentSubmissionView do
  use MagpieWeb, :view
  alias MagpieWeb.ExperimentSubmissionView

  def render("index.json", %{experiment_submissions: experiment_submissions}) do
    %{
      data:
        render_many(
          experiment_submissions,
          ExperimentSubmissionView,
          "experiment_submission.json"
        )
    }
  end

  def render("show.json", %{experiment_submission: experiment_submission}) do
    %{
      data:
        render_one(experiment_submission, ExperimentSubmissionView, "experiment_submission.json")
    }
  end

  def render("experiment_submission.json", %{experiment_submission: experiment_submission}) do
    %{
      id: experiment_submission.id,
      results: experiment_submission.results,
      is_intermediate: experiment_submission.is_intermediate,
      slot_identifier: experiment_submission.slot_identifier
    }
  end
end
