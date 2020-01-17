# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Phlog.Repo.insert!(%Phlog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Phlog.Repository.Document
alias Phlog.Repository

{:ok, %Document{}} = Repository.create_document(%{
  html: "<div>Document1</div>",
  title: "Document 1",
  render_timestamp: DateTime.utc_now(),
  filename: "none.txt"
})
{:ok, %Document{}} = Repository.create_document(%{
  html: "<div>Document2</div>",
  title: "Document 2",
  render_timestamp: DateTime.utc_now(),
  filename: "none.txt"
})
{:ok, %Document{}} = Repository.create_document(%{
  html: "<div>Document3</div>",
  title: "Document 3",
  render_timestamp: DateTime.utc_now(),
  filename: "none.txt"
})
