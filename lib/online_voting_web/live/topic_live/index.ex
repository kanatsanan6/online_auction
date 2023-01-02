defmodule OnlineVotingWeb.TopicLive.Index do
  use OnlineVotingWeb, :live_view

  alias OnlineVoting.Votings
  alias OnlineVoting.Votings.Topic

  require Logger

  @topic "voting"

  @impl true
  def mount(_params, _session, socket) do
    OnlineVotingWeb.Endpoint.subscribe(@topic)

    {:ok,
     socket
     |> assign(:topics, list_topics())
     |> assign(:countdown, 120)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    topics = list_topics()
    OnlineVotingWeb.Endpoint.broadcast_from(self(), @topic, "topic_event", topics)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Topic")
    |> assign(:topic, Votings.get_topic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Topic")
    |> assign(:topic, %Topic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Topics")
    |> assign(:topic, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    topic = Votings.get_topic!(id)
    {:ok, _} = Votings.delete_topic(topic)

    {:noreply, assign(socket, :topics, list_topics())}
  end

  @impl true
  def handle_event("create", %{"topic" => topic_params}, socket) do
    case Votings.create_topic(topic_params) do
      {:ok, _topic} ->
        topics = list_topics()
        OnlineVotingWeb.Endpoint.broadcast_from(self(), @topic, "topic_event", topics)
        socket
        |> redirect(to: Routes.topic_index_path(socket, :index))
        {:noreply, assign(socket, :topics, topics)}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info(%{topic: @topic, payload: topics}, socket) do
    {:noreply, assign(socket, :topics, topics)}
  end

  defp list_topics do
    Votings.list_topics()
  end
end
