defmodule Masque.Migrations.Postgres do
  use Ecto.Migration

  def up() do
    create table(:masque_content_types, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:schema, :json)

      timestamps()
    end
  end

  def down() do
    drop_if_exists(table(:masque_content_types))
  end
end
