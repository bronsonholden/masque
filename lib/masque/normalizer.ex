defmodule Masque.Normalizer do
  @moduledoc """
  Provides methods for normalizing a content item's `data` field into a plain map.
  Embeds nested content items.
  """

  alias Masque.ContentItem

  def normalize(%ContentItem{} = content_item) do
    normalize(content_item.data["root"])
  end

  def normalize(%{} = data) do
    Enum.map(data, fn
      {key, value} -> {key, normalize(value)}
    end)
    |> Enum.into(%{})
  end

  def normalize(data), do: data
end
