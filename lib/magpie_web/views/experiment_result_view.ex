defmodule MagpieWeb.ExperimentResultView do
  use MagpieWeb, :view
  alias MagpieWeb.ExperimentResultView

  def render("index.json", %{experiment_results: experiment_results}) do
    %{data: render_many(experiment_results, ExperimentResultView, "experiment_result.json")}
  end

  def render("show.json", %{experiment_result: experiment_result}) do
    %{data: render_one(experiment_result, ExperimentResultView, "experiment_result.json")}
  end

  def render("experiment_result.json", %{experiment_result: experiment_result}) do
    %{
      id: experiment_result.id,
      results: experiment_result.results,
      is_intermediate: experiment_result.is_intermediate,
      identifier: experiment_result.identifier
    }
  end
end
