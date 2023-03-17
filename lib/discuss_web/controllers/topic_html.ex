defmodule DiscussWeb.TopicHTML do
  use DiscussWeb, :html
  import Phoenix.HTML.Form
  import Phoenix.HTML.Link
  import Discuss.ErrorHelpers


  embed_templates "topic_html/*"
end
