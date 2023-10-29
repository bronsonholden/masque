Application.ensure_all_started(:postgrex)
Masque.Test.Repo.start_link()
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Masque.Test.Repo, :manual)
