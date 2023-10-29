defmodule Masque.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    resolver = Application.get_env(:masque, :resolver)
    Application.put_env(:ex_json_schema, :remote_schema_resolver, {resolver, :resolve})

    Supervisor.start_link([], strategy: :one_for_one, name: __MODULE__)
  end
end
