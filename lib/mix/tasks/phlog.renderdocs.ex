defmodule Mix.Tasks.Phlog.RenderDocs do
  import Ecto.Query, only: [from: 2]
  use Mix.Task
  alias Phlog.Repo
  alias Phlog.Repository
  alias Phlog.Repository.Document

  @shortdoc "Load and render Markdown documents"

  @moduledoc """
  Load Markdown documents, rendering to HTML and saving in the database
  """

  def run(_args) do
    Mix.Task.run("app.start")  # this is needed to bring Ecto Repos up
    base_path = Path.join(["assets", "docs"])
    files = base_path
            |> File.ls!()
            |> Enum.filter(fn x -> String.ends_with?(x, ".md") end)

    Mix.shell().info("Rendering documents...")
    Mix.shell().info("List of files: #{inspect files}")

    files
    |> Enum.map(fn file -> %{
      html: Earmark.as_html!(File.read!(Path.join(base_path, file))),
      title: file,
      render_timestamp: DateTime.utc_now(),
      filename: file
    } end)
    |> Enum.each(&upsert/1)
  end

  def upsert(document) do
    query = from d in Document,
            where: d.filename == ^document.filename,
            select: d
    existing_document = Repo.one(query)
    case existing_document do
      nil -> Repository.create_document(document)
      _   -> Repository.update_document(existing_document, document)
    end
  end
end
