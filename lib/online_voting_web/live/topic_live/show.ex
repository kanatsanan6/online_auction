defmodule OnlineVotingWeb.TopicLive.Show do
  use OnlineVotingWeb, :live_view

  alias OnlineVoting.Votings

  @topic "voting"

  @impl true
  def mount(params, _session, socket) do
    topic = Votings.get_topic!(params["id"])

    OnlineVotingWeb.Endpoint.subscribe(@topic)

    {:ok, socket |> assign(:topic, topic)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    topic = Votings.get_topic!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:topic, topic)
     |> assign(:percentage, "width: #{voting_percentage(topic.agreed, topic.disagreed)}%")}
  end

  defp voting_percentage(choice_1, choice_2) do
    if choice_1 + choice_2 == 0, do: 50,
    else: (choice_1 / (choice_1 + choice_2)) * 100
  end

  def handle_event("agreed", %{"id" => id}, socket) do
    topic = Votings.get_topic!(id)

    case Votings.update_topic(topic, %{agreed: topic.agreed + 1}) do
      {:ok, topic} ->
        OnlineVotingWeb.Endpoint.broadcast_from(self(), @topic, "topic_event", topic)
        {:noreply,
         socket
         |> assign(:topic, topic)
         |> assign(:percentage, "width: #{voting_percentage(topic.agreed, topic.disagreed)}%")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("disagreed", %{"id" => id}, socket) do
    topic = Votings.get_topic!(id)

    case Votings.update_topic(topic, %{disagreed: topic.disagreed + 1}) do
      {:ok, topic} ->
        OnlineVotingWeb.Endpoint.broadcast_from(self(), @topic, "topic_event", topic)
        {:noreply,
         socket
         |> assign(:topic, topic)
         |> assign(:percentage, "width: #{voting_percentage(topic.agreed, topic.disagreed)}%")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_info(%{topic: @topic, payload: topic}, socket) do
    {:noreply,
     socket
     |> assign(:topic, topic)
     |> assign(:percentage, "width: #{voting_percentage(topic.agreed, topic.disagreed)}%")}
  end

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
end
