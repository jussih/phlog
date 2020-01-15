defmodule Phlog.Repository.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repository_documents" do
    field :html, :string
    field :render_timestamp, :utc_datetime
    field :title, :string
    field :filename, :string

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:html, :title, :render_timestamp, :filename])
    |> validate_required([:html, :title, :render_timestamp, :filename])
  end
end
