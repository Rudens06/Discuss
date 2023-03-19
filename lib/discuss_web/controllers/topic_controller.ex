defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  import Ecto
  alias Discuss.Repo
  alias Discuss.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]


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
    changeset =
      conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

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
    |> put_flash(:info, "Deleted Successfully")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn


    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "Not Allowed")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end

end
