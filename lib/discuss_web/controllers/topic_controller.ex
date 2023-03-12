defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  def new(conn, _params) do
    changeset = Topic.topic_changeset(%Topic{}, %{})

      conn
      |> assign(:changeset, changeset)
      |> render(:new)
  end

  def create(conn, _params) do

  end

end
