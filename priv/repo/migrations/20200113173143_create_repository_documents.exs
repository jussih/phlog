defmodule Phlog.Repo.Migrations.CreateRepositoryDocuments do
  use Ecto.Migration

  def change do
    create table(:repository_documents) do
      add :html, :text
      add :title, :string
      add :filename, :string
      add :render_timestamp, :utc_datetime

      timestamps()
    end

  end
end
