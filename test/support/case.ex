defmodule Masque.Case do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Masque.Case

      alias Masque.Test.Repo
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Masque.Test.Repo)
  end
end
