defmodule Enver.BooleanParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, boolean()}

  #######
  # API #
  #######

  @doc """
  Converts the given binary to an boolean.

      iex(1)> Enver.BooleanParser.parse("true", %{type: :boolean})
      {:ok, true}
  """
  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, %{type: :boolean}) when is_binary(val) do
    case String.downcase(val) do
      "false" ->
        {:ok, false}

      "true" ->
        {:ok, true}

      _ ->
        {:error, "invalid boolean"}
    end
  end
end
