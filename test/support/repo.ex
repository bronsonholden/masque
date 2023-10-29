defmodule Masque.Test.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :masque,
    adapter: Ecto.Adapters.Postgres
end
