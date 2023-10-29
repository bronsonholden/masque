defmodule Masque.Test do
  use Masque.Case

  alias Masque.{ContentItem, ContentType}
  alias Masque.Test.Repo

  @schema %{
    "type" => "object",
    "properties" => %{
      "first_name" => %{"type" => "string"},
      "last_name" => %{"type" => "string"}
    },
    "required" => ["first_name", "last_name"]
  }

  setup do
    {:ok, content_type} =
      ContentType.new(%{name: "people", version: 1, schema: @schema})
      |> Repo.insert()

    %{content_type: content_type}
  end

  describe "get_content_type_by_schema_id/1" do
    test "returns matching content type", %{content_type: content_type} do
      id = Map.get(content_type.schema, "$id")
      assert Masque.get_content_type_by_schema_id(id) == content_type
    end

    test "returns no result for invalid schema ID" do
      refute Masque.get_content_type_by_schema_id("/schemas/businesses/v1")
    end
  end

  describe "list_content_items/1" do
    setup %{content_type: content_type} do
      {:ok, content_item} =
        ContentItem.new(content_type, %{data: %{"first_name" => "John", "last_name" => "Doe"}})
        |> Repo.insert()

      %{content_item: content_item}
    end

    test "returns matching content items", %{
      content_item: content_item,
      content_type: content_type
    } do
      id = Map.get(content_type.schema, "$id")
      assert Masque.list_content_items(id) == [content_item]
    end

    test "returns no results for invalid schema ID" do
      assert Masque.list_content_items("/schemas/businesses/v1") == []
    end
  end

  describe "publish/1" do
    setup %{content_type: content_type} do
      {:ok, content_item} =
        ContentItem.new(content_type, %{data: %{"first_name" => "John", "last_name" => "Doe"}})
        |> Repo.insert()

      %{content_item: content_item}
    end

    test "publishes at current time", %{
      content_item: content_item,
      content_type: content_type
    } do
      assert {:ok, content_item} = Masque.publish(content_item)

      id = Map.get(content_type.schema, "$id")
      assert Masque.list_published_content_items(id) == [content_item]
    end

    test "publishes at future time", %{
      content_item: content_item,
      content_type: content_type
    } do
      at = DateTime.utc_now() |> DateTime.add(1, :day)
      assert {:ok, content_item} = Masque.publish(content_item, at)

      id = Map.get(content_type.schema, "$id")
      assert Masque.list_published_content_items(id) == []
      assert Masque.list_published_content_items(id, at) == [content_item]
    end
  end
end
