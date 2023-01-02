defmodule OnlineAuctionWeb.ItemLive.FormComponent do
  use OnlineAuctionWeb, :live_component

  alias OnlineAuction.Auctions

  @topic "auction"

  @impl true
  def update(%{item: item} = assigns, socket) do
    changeset = Auctions.change_item(item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"item" => item_params}, socket) do
    changeset =
      socket.assigns.item
      |> Auctions.change_item(item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"item" => item_params}, socket) do
    save_item(socket, socket.assigns.action, item_params)
  end

  defp save_item(socket, :edit, item_params) do
    case Auctions.update_item(socket.assigns.item, item_params) do
      {:ok, _item} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_item(socket, :new, item_params) do
    case Auctions.create_item(item_params) do
      {:ok, _item} ->
        items = list_items()
        OnlineAuctionWeb.Endpoint.broadcast_from(self(), @topic, "item_event", items)
        {:noreply,
         socket
         |> assign(:items, list_items())
         |> put_flash(:info, "Item created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp list_items do
    Auctions.list_items()
  end
end
