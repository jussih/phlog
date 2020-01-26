defmodule Mix.Tasks.Phlog.RenderDocs do
  use Mix.Task

  @shortdoc "Load and render Markdown documents"

  @moduledoc """
  Load Markdown documents, rendering to HTML and saving in the database
  """

  def run(_args) do
    Mix.Task.run("app.start")  # this is needed to bring Ecto Repos up
    Phlog.RenderDocs.render()
  end
end
