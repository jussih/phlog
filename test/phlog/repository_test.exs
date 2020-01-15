defmodule Phlog.RepositoryTest do
  use Phlog.DataCase

  alias Phlog.Repository

  describe "repository_documents" do
    alias Phlog.Repository.Document

    @valid_attrs %{html: "some html", render_timestamp: "2010-04-17T14:00:00Z", title: "some title"}
    @update_attrs %{html: "some updated html", render_timestamp: "2011-05-18T15:01:01Z", title: "some updated title"}
    @invalid_attrs %{html: nil, render_timestamp: nil, title: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Repository.create_document()

      document
    end

    test "list_repository_documents/0 returns all repository_documents" do
      document = document_fixture()
      assert Repository.list_repository_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Repository.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Repository.create_document(@valid_attrs)
      assert document.html == "some html"
      assert document.render_timestamp == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert document.title == "some title"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Repository.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = Repository.update_document(document, @update_attrs)
      assert document.html == "some updated html"
      assert document.render_timestamp == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert document.title == "some updated title"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Repository.update_document(document, @invalid_attrs)
      assert document == Repository.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Repository.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Repository.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Repository.change_document(document)
    end
  end
end
