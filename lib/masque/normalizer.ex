defmodule Masque.Normalizer do
  @moduledoc """
  Provides methods for normalizing a content item's `data` field into a plain map.
  Embeds nested content items with a special `$content_item` property that contains
  the ID of the content item that was embedded, for reference.
  """

  alias Masque.ContentItem

  def normalize(%ContentItem{} = content_item) do
    normalize(content_item.data["root"])
    |> Map.put("$content_item", content_item.id)
  end

  def normalize(%{} = data) do
    Enum.map(data, fn
      {key, value} -> {key, normalize(value)}
    end)
    |> Enum.into(%{})
  end

  def normalize(data), do: data
end
