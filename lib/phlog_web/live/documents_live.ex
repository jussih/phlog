defmodule PhlogWeb.DocumentsLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Phlog.Repository
  require Logger

  def render(assigns) do
    ~L"""
    <section class="container">
      <div class="columns">
        <div class="column is-one-quarter">
          <aside class="menu">
            <p class="menu-label">
              Documents
            </p>
            <div class="field">
              <div class="control">
                <input class="input" autofocus="true" placeholder="Search..." phx-keyup="filter_keyup">
              </div>
            </div>
            <ul class="menu-list">
              <%= for document <- @filtered_documents do %>
                <li phx-click="document_click<%= document.id %>">
                  <a
                    class="<%= if document == @active_document do %>is-active<% end %> <%= if document.id == @focused_document_id do %> focused<% end %>"
                  >
                    <%= document.title %>
                  </a>
                </li>
              <% end %>
            </ul>
          </aside>
        </div>
        <div class="column">
          <%= raw @active_document.html %>
        </div>
      </div>
    </section>
    """
  end

  def mount(_assigns, socket) do
    documents = Repository.list_repository_documents()
    {:ok, socket
          |> assign(:filter, "")
          |> assign(:documents, documents)
          |> assign(:filtered_documents, documents)
          |> assign(:focused_document_id, hd(documents).id)
          |> assign(:active_document, hd(documents))
    }
  end

  def get_focus_document(
    _key,
    %Phoenix.LiveView.Socket{assigns: %{documents: []}}
  ) do
    nil
  end
  def get_focus_document(
    key,
    %Phoenix.LiveView.Socket{assigns: %{filtered_documents: documents, focused_document_id: focused_document}}
  ) do
    case key["key"] do
      "ArrowUp" -> previous_document(documents, focused_document).id
      "ArrowDown" -> next_document(documents, focused_document).id
      _ -> focused_document
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

  def handle_event("filter_keyup", %{"key" => "Enter"}, socket) do
    active_document = Enum.find(socket.assigns.documents, fn d -> d.id == socket.assigns.focused_document_id end)
    active_document = case active_document do
      nil -> socket.assigns.active_document
      _   -> active_document
    end
    {:noreply, assign(socket, :active_document, active_document)}
  end

  def handle_event("filter_keyup", %{"key" => keyname} = key, socket) when keyname == "ArrowUp" or keyname == "ArrowDown" do
    {:noreply, assign(socket, :focused_document_id, get_focus_document(key, socket))}
  end

  def handle_event("filter_keyup", payload, socket) do
    filter_value = payload["value"]
    filtered_documents = case filter_value do
      "" -> socket.assigns.documents
      _  -> Enum.filter(socket.assigns.documents, fn doc ->
              String.contains?(doc.title, filter_value)
            end)
    end
    focused_document_id = case filtered_documents do
      [] -> nil
      _  -> hd(filtered_documents).id
    end
    {:noreply, socket
    |> assign(:filter, filter_value)
    |> assign(:filtered_documents, filtered_documents)
    |> assign(:focused_document_id, focused_document_id)}
  end

  def handle_event("document_click" <> document_id, _payload, socket) do
    clicked_id = String.to_integer(document_id)
    active_document = Enum.find(socket.assigns.documents, fn d -> d.id == clicked_id end)
    {:noreply, socket
               |> assign(:active_document, active_document)
               |> assign(:focused_document_id, active_document.id)}
  end

  def handle_event(_event, _payload, socket) do
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
