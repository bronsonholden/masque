defmodule Masque.ContentItemTest do
  use Masque.Case

  alias Masque.{ContentItem, ContentType}
  alias Masque.Test.Repo

  setup do
    {:ok, people} =
      ContentType.new(%{
        name: "people",
        version: 1,
        schema: %{
          "type" => "object",
          "properties" => %{
            "first_name" => %{"type" => "string"},
            "last_name" => %{"type" => "string"}
          }
        }
      })
      |> Repo.insert()

    {:ok, companies} =
      ContentType.new(%{
        name: "companies",
        version: 1,
        schema: %{
          "type" => "object",
          "properties" => %{
            "name" => %{"type" => "string"},
            "owner" => %{"$ref" => "/schemas/people/v1"}
          }
        }
      })
      |> Repo.insert()

    %{people: people, companies: companies}
  end

  describe "create a ContentItem" do
    test "with valid data", %{people: people} do
      assert {:ok, content_item} =
               ContentItem.new(people, %{data: %{"first_name" => "John"}})
               |> Repo.insert()

      refute content_item.published_at
    end

    test "with valid data for remote schema", %{companies: companies} do
      assert {:ok, _} =
               ContentItem.new(companies, %{
                 data: %{
                   "name" => "ACME, Inc.",
                   "owner" => %{"first_name" => "Jane", "last_name" => "Roe"}
                 }
               })
               |> Repo.insert()
    end

    test "with invalid data", %{people: people} do
      assert {:error, _} =
               ContentItem.new(people, %{data: %{"first_name" => 123}})
               |> Repo.insert()
    end

    test "with invalid data for remote schema", %{companies: companies} do
      assert {:error, %Ecto.Changeset{}} =
               ContentItem.new(companies, %{
                 data: %{
                   "name" => "ACME, Inc.",
                   "owner" => %{"first_name" => 123, "last_name" => "Roe"}
                 }
               })
               |> Repo.insert()
    end

    test "as published", %{people: people} do
      assert {:ok, content_item} =
               ContentItem.new(people, %{data: %{"first_name" => "Jane"}})
               |> ContentItem.published()
               |> Repo.insert()

      assert content_item.published_at
    end
  end
end
