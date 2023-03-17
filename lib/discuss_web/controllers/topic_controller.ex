defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Repo
  alias Discuss.Topic


  def index(conn, _params) do
    topics = Repo.all(Topic)
    conn
    |>assign(:topics, topics)
    |>render(:index)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

      conn
      |> assign(:changeset, changeset)
      |> render(:new)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    conn
    |> assign(:changeset, changeset)
    |> assign(:topic, topic)
    |> render(:edit)
  end

  def update(conn, %{"topic" => topic_params, "id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic, topic_params)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Post Updated Successfully")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:topic, topic)
        |> assign(:changeset, changeset)
        |> render(:edit)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Delete Successfully")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

end
