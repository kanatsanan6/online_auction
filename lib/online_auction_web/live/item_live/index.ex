defmodule OnlineAuctionWeb.ItemLive.Index do
  use OnlineAuctionWeb, :live_view

  alias OnlineAuction.Auctions
  alias OnlineAuction.Auctions.Item

  require Logger

  @topic "auction"

  @impl true
  def mount(_params, _session, socket) do
    OnlineAuctionWeb.Endpoint.subscribe(@topic)

    {:ok,
     socket
     |> assign(:items, list_items())
     |> assign(:countdown, 120)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    items = list_items()
    OnlineAuctionWeb.Endpoint.broadcast_from(self(), @topic, "item_event", items)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Auctions.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:item, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Auctions.get_item!(id)
    {:ok, _} = Auctions.delete_item(item)

    {:noreply, assign(socket, :items, list_items())}
  end

  @impl true
  def handle_event("create", %{"item" => item_params}, socket) do
    case Auctions.create_item(item_params) do
      {:ok, _item} ->
        items = list_items()
        OnlineAuctionWeb.Endpoint.broadcast_from(self(), @topic, "item_event", items)
        socket
        |> redirect(to: Routes.item_index_path(socket, :index))
        {:noreply, assign(socket, :items, items)}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info(%{topic: @topic, payload: items}, socket) do
    {:noreply, assign(socket, :items, items)}
  end

  defp list_items do
    Auctions.list_items()
  end
end
