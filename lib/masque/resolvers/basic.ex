defmodule Masque.Resolvers.Basic do
  @moduledoc """
  Basic resolver queries the database for a matching content type
  by name and version. This resolver will never load remote schemas.
  """

  @behaviour Masque.Resolver

  @impl Masque.Resolver
  def resolve(url) do
    Masque.get_content_type_by_schema_id(url).schema
  end
end
