defmodule Masque.ContentType do
  use Ecto.Schema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  @typep schema_atom :: String.t() | integer() | boolean() | nil
  @typep schema_term :: schema_atom() | [schema_atom()]
  @typep schema :: %{String.t() => schema_term()} | schema_term()

  @type t :: %__MODULE__{
          schema: schema(),
          name: String.t(),
          version: pos_integer()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "masque_content_types" do
    field(:schema, :map)
    field(:name, :string)
    field(:version, :integer)
    timestamps()
  end

  def new(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:name, :schema, :version])
    |> validate_required([:name, :schema, :version])
    |> validate_format(:name, ~r/[a-z_-]/)
    |> maybe_put_schema_id()
    |> maybe_put_schema_dialect()
  end

  defp maybe_put_schema_id(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp maybe_put_schema_id(changeset) do
    name = Ecto.Changeset.get_change(changeset, :name)
    version = Ecto.Changeset.get_change(changeset, :version)

    schema =
      changeset
      |> Ecto.Changeset.get_change(:schema)
      |> Map.put("$id", "/schemas/#{name}/v#{version}")

    Ecto.Changeset.put_change(changeset, :schema, schema)
  end

  defp maybe_put_schema_dialect(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp maybe_put_schema_dialect(changeset) do
    schema =
      changeset
      |> Ecto.Changeset.get_change(:schema)
      |> Map.put("$schema", "http://json-schema.org/draft-07/schema#")

    Ecto.Changeset.put_change(changeset, :schema, schema)
  end
end
