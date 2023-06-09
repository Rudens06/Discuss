defmodule Discuss.ErrorHelpers do

  use Phoenix.HTML

  import DiscussWeb.CoreComponents

  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: "help-block"
    end
  end
end
