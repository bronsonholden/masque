defmodule Masque.ValidatorTest do
  use Masque.Case

  alias Masque.ContentType
  alias Masque.Test.Repo

  setup do
    {:ok, %{schema: %{"$id": id}}} =
      ContentType.new(%{name: "name", version: 1, schema: %{type: "string"}})
      |> Repo.insert()

    {:ok, people} =
      ContentType.new(%{
        name: "people",
        version: 1,
        schema: %{
          type: "object",
          properties: %{
            first_name: %{"$ref": id},
            last_name: %{"$ref": id}
          },
          required: ["first_name", "last_name"]
        }
      })
      |> Repo.insert()

    %{people: people}
  end

  describe "validate" do
    test "resolves remote schema", %{people: people} do
      assert :ok =
               Masque.Validator.validate(people, %{
                 "first_name" => "John",
                 "last_name" => "Doe"
               })

      assert {:error, _} =
               Masque.Validator.validate(people, %{
                 "first_name" => "John",
                 "last_name" => 123
               })
    end
  end

  describe "valid?" do
    test "resolves remote schema", %{people: people} do
      assert Masque.Validator.valid?(people, %{
               "first_name" => "John",
               "last_name" => "Doe"
             })

      refute Masque.Validator.valid?(people, %{
               "first_name" => "John",
               "last_name" => 123
             })
    end
  end
end
