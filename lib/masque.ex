defmodule Masque do
  alias Masque.ContentType

  import Ecto.Query

  def get_content_type_by_schema_id(id) do
    ["", "schemas", name, "v" <> version] = String.split(id, "/")

    repo = Application.get_env(:masque, :repo)

    from(c in ContentType, where: c.name == ^name and c.version == ^version)
    |> repo.one()
  end
end
