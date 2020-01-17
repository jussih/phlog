defmodule PhlogWeb.DocumentsLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Phlog.Repository
  require Logger

  def render(assigns) do
    visible_documents =
      case assigns.filter do
        "" -> assigns.documents
        _  -> Enum.filter(assigns.documents, fn doc -> String.contains?(doc.title, assigns.filter) end)
      end
    ~L"""
    <div phx-keydown="keydown" phx-target="window">
      <input phx-keyup="filter_change">
      <%= for document <- visible_documents do %>
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
          |> assign(:filter, "")
          |> assign(:documents, documents)
          |> assign(:active_document, hd(documents).id)
    }
  end

  def get_active_document(
    _key,
    %Phoenix.LiveView.Socket{assigns: %{documents: []}}
  ) do
    nil
  end
  def get_active_document(
    key,
    %Phoenix.LiveView.Socket{assigns: %{documents: documents, active_document: active_document}}
  ) do
    case key["key"] do
      "ArrowUp" -> previous_document(documents, active_document).id
      "ArrowDown" -> next_document(documents, active_document).id
      _ -> active_document
    end
  end

  def previous_document([], _), do: nil
  def previous_document([head | []], _), do: head
  def previous_document([head | tail], id) do
    cond do
      head.id == id -> head
      hd(tail).id == id -> head
      true -> previous_document(tail, id)
    end
  end

  def next_document([], _), do: nil
  def next_document([head | []], _), do: head
  def next_document([head | tail], id) do
    cond do
      head.id == id -> hd(tail)
      true -> next_document(tail, id)
    end
  end

  def handle_event("keydown", key, socket) do
    {:noreply, assign(socket, :active_document, get_active_document(key, socket))}
  end

  def handle_event("filter_change", payload, socket) do
    {:noreply, assign(socket, :filter, payload["value"])}
  end

  def handle_event("document_click" <> document_id, _payload, socket) do
    Logger.debug(fn -> "Document clicked: #{document_id}" end)
    {:noreply, assign(socket, :active_document, String.to_integer(document_id))}
  end

  def handle_event(_event, _payload, socket) do
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
