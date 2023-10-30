defmodule Masque.Resolver do
  @moduledoc """
  Defines behaviour for fetching remote schemas.
  """

  @callback resolve(String.t()) :: map()
end
