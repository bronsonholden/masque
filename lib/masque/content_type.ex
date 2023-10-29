defmodule Masque.ContentType do
  use Ecto.Schema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "masque_content_types" do
    field(:schema, :map)
    timestamps()
  end

  def new(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:schema])
    |> validate_required([:schema])
  end
end
