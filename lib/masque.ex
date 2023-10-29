defmodule Masque do
  alias Masque.{ContentItem, ContentType}

  import Ecto.Query

  def get_content_type_by_schema_id(id) do
    ["", "schemas", name, "v" <> version] = String.split(id, "/")

    repo = Application.get_env(:masque, :repo)

    from(c in ContentType, where: c.name == ^name and c.version == ^version)
    |> repo.one()
  end

  def get_content_items_by_schema_id(id) do
    repo = Application.get_env(:masque, :repo)

    from(c in ContentItem, where: c.uri == ^id)
    |> repo.all()
  end

  def publish(content_item, at \\ DateTime.utc_now()) do
    repo = Application.get_env(:masque, :repo)

    content_item
    |> ContentItem.publish_changeset(at)
    |> repo.update()
  end
end
