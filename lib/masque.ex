defmodule Masque do
  alias Masque.{ContentItem, ContentType}

  import Ecto.Query

  def get_content_type_by_schema_id(id) do
    ["", "schemas", name, "v" <> version] = String.split(id, "/")

    repo = Application.get_env(:masque, :repo)

    from(c in ContentType, where: c.name == ^name and c.version == ^version)
    |> repo.one()
  end

  @doc """
  List all content items for the content type identified by the given schema ID

  ## Examples

      iex> list_content_items("/schemas/businesses/v1")
      [%ContentItem{...}]

      iex> list_content_items("/schemas/mythical-creatures/v1")
      []
  """
  def list_content_items(schema_id) do
    repo = Application.get_env(:masque, :repo)

    from(c in ContentItem, where: c.uri == ^schema_id)
    |> repo.all()
  end

  @doc """
  List all published content items for the content type identified by the given schema ID

  ## Examples

      iex> list_published_content_items("/schemas/schools/v1", DateTime.utc_now())
      [%ContentItem{...}]

      iex> list_content_items("/schemas/aliens/v1", DateTime.utc_now())
      []
  """
  def list_published_content_items(schema_id, at \\ DateTime.utc_now()) do
    repo = Application.get_env(:masque, :repo)

    from(c in ContentItem, where: c.uri == ^schema_id and c.published_at <= ^at)
    |> repo.all()
  end

  @doc """
  Set the `published_at` field for a content item to the given time.

  ## Examples

      iex> publish(content_item, DateTime.utc_now())
      {:ok, %ContentItem{}}

      iex publish(content_item, DateTime.utc_now())
      {:error, %Ecto.Changeset{}}
  """
  def publish(content_item, at \\ DateTime.utc_now()) do
    repo = Application.get_env(:masque, :repo)

    content_item
    |> ContentItem.published(at)
    |> repo.update()
  end
end
