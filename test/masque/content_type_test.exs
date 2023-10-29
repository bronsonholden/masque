defmodule Masque.ContentTypeTest do
  use Masque.Case

  alias Masque.ContentType
  alias Masque.Test.Repo

  describe "create a ContentType" do
    test "with valid attributes" do
      assert {:ok, _content_type} =
               ContentType.new(%{schema: %{type: "string"}})
               |> Repo.insert()
    end

    test "with invalid attributes" do
      assert {:error, %Ecto.Changeset{valid?: false}} =
               ContentType.new(%{})
               |> Repo.insert()
    end
  end
end
