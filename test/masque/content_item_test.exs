defmodule Masque.ContentItemTest do
  use Masque.Case

  alias Masque.{ContentItem, ContentType}
  alias Masque.Test.Repo

  setup do
    {:ok, content_type} =
      ContentType.new(%{name: "first_name", version: 1, schema: %{type: "string"}})
      |> Repo.insert()

    %{content_type: content_type}
  end

  describe "create a ContentItem" do
    test "with valid data", %{content_type: content_type} do
      assert {:ok, _} =
               ContentItem.new(content_type, %{data: "John"})
               |> Repo.insert()
    end

    test "with invalid attributes", %{content_type: content_type} do
      assert {:error, _} =
               ContentItem.new(content_type, %{data: 123})
               |> Repo.insert()
    end
  end
end
