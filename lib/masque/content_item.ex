defmodule Masque.ContentItem do
  use Ecto.Schema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  @type t :: %__MODULE__{
          uri: String.t(),
          data: map(),
          published_at: DateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "masque_content_items" do
    field(:uri, :string)
    field(:title, :string)
    field(:data, :map)
    field(:description, :string)
    field(:published_at, :utc_datetime)
    timestamps()
  end

  @doc """
  Build a new content item struct for a content type with the given attributes. By
  default, content items are built as unpublished. Use `published/2` to publish an
  item on insertion.

  ## Examples

      iex> new(content_type, %{data: %{"name" => "Jane Roe"}})
      %Ecto.Changeset{}
  """
  def new(content_type, attrs) do
    {_, attrs} =
      Map.get_and_update(attrs, :data, fn
        nil -> {nil, %{"root" => nil}}
        data -> {data, %{"root" => Masque.Normalizer.normalize(data)}}
      end)

    %__MODULE__{}
    |> cast(attrs, [:data, :description, :title])
    |> put_schema_uri(content_type)
    |> validate_required([:uri, :data])
    |> validate_content_type_schema(content_type)
  end

  @doc """
  Create a changeset for the given content item or changeset to publish it
  at the given time.

  ## Examples

      iex> published(content_item)
      %Ecto.Changeset{}
  """
  def published(content_item_or_changeset, at \\ DateTime.utc_now()) do
    cast(content_item_or_changeset, %{published_at: at}, [:published_at])
  end

  defp put_schema_uri(changeset, content_type) do
    Ecto.Changeset.put_change(
      changeset,
      :uri,
      "/schemas/#{content_type.name}/v#{content_type.version}"
    )
  end

  defp validate_content_type_schema(changeset, content_type) do
    %{"root" => root} = Ecto.Changeset.get_change(changeset, :data)

    case Masque.Validator.validate(content_type, root) do
      :ok ->
        changeset

      {:error, errors} ->
        errors
        |> Enum.reduce(changeset, fn {message, path}, changeset ->
          Ecto.Changeset.add_error(changeset, :"data#{path}", message)
        end)
        |> Ecto.Changeset.add_error(:data, "does not match schema")
    end
  end
end
