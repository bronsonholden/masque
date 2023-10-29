import Config

config :logger, level: :info

config :masque, Masque.Test.Repo,
  name: Masque.Test.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "test/support/priv",
  url: System.get_env("DATABASE_URL", "postgres://localhost:5432/masque_test")

config :masque,
  ecto_repos: [Masque.Test.Repo]

config :ex_json_schema,
       :remote_schema_resolver,
       {Masque.Resolvers.Basic, :resolve}
