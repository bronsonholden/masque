defmodule Masque.NormalizerTest do
  use Masque.Case

  alias Masque.{ContentItem, ContentType}

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

    %{people: people}
  end

  describe "normalize" do
    test "normalizes a plain content item" do
      data = %{"name" => "ACME, Inc."}

      assert Masque.Normalizer.normalize(data) == %{"name" => "ACME, Inc."}
    end

    test "normalizes an embedded content item", %{people: people} do
      {:ok, person} =
        ContentItem.new(people, %{data: %{"first_name" => "John", "last_name" => "Doe"}})
        |> Repo.insert()

      data = %{"name" => "ACME, Inc.", "owner" => person}

      assert Masque.Normalizer.normalize(data) == %{
               "name" => "ACME, Inc.",
               "owner" => %{"first_name" => "John", "last_name" => "Doe"}
             }
    end
  end
end
