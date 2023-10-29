defmodule Masque.Resolver do
  @moduledoc """
  Defines behaviour for fetching remote schemata.
  """

  @callback resolve(String.t()) :: map()
end
