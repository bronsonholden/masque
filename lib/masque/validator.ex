defmodule Masque.Validator do
  alias Masque.ContentType

  @spec validate(ContentType.t(), map()) :: :ok | {:error, term()}
  def validate(%ContentType{} = content_type, payload) do
    content_type
    |> stringified_schema()
    |> ExJsonSchema.Schema.resolve()
    |> ExJsonSchema.Validator.validate(payload, error_formatter: false)
    |> case do
      :ok ->
        :ok

      {:error, _errors} ->
        {:error, "Invalid schema"}
    end
  end

  def valid?(%ContentType{} = content_type, payload) do
    content_type
    |> stringified_schema()
    |> ExJsonSchema.Schema.resolve()
    |> ExJsonSchema.Validator.valid?(payload)
  end

  @spec stringified_schema(ContentType.t()) :: map()
  defp stringified_schema(%ContentType{schema: schema}) do
    schema
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
