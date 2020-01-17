defmodule PhlogWeb.DocumentsLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Phlog.{Repository, Repo}
  require Logger

  def render(assigns) do
    ~L"""
    <div phx-keydown="keydown" phx-target="window">
      <%= for document <- @documents do %>
        <div class="<%= if document.id == @active_document do %>active<% end %>" phx-click="document_click<%= document.id %>">
          <b><%= document.title %></b>: <%= document.html %>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(_assigns, socket) do
    documents = Repository.list_repository_documents()
    {:ok, socket
          |> assign(:documents, documents)
          |> assign(:active_document, hd(documents).id)
    }
  end

  def handle_event("document_click" <> document_id, _payload, socket) do
    Logger.debug(fn -> "Document clicked: #{document_id}" end)
    {:noreply, assign(socket, :active_document, String.to_integer(document_id))}
  end

  def handle_event("keydown", key, socket) do
    Logger.debug(fn -> "Key pressed #{inspect key}" end)
    {:noreply, assign(socket, :active_document, get_active_document(key, socket))}
  end

  def get_active_document(
    key,
    %Phoenix.LiveView.Socket{assigns: %{documents: documents, active_document: active_document}} = socket
  ) do
    active_idx = Enum.find_index(documents, fn d -> d.id == active_document end)
    case key["key"] do
      "ArrowUp" -> Enum.at(documents, rem(active_idx - 1, Enum.count(documents))).id
      "ArrowDown" -> Enum.at(documents, rem(active_idx + 1, Enum.count(documents))).id
      _ -> active_document
    end
  end

  def handle_event(event, payload, socket) do
    {:noreply, socket}
  end

  def handle_params(params, uri, socket) do
    {:noreply, socket}
  end
end
