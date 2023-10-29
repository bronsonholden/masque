defmodule Masque.Test.Repo.Migrations.SetupMasque do
  use Ecto.Migration

  def up do
    Masque.Migrations.Postgres.up()
  end

  def down do
    Masque.Migrations.Postgres.down()
  end
end
