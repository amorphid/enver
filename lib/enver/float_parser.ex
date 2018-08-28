defmodule Enver.FloatParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, float()}

  #######
  # API #
  #######

  @doc """
  Converts the given binary to an float.

      iex(1)> Enver.FloatParser.parse("1.23", %{type: :float})
      {:ok, 1.23}
  """
  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, %{type: :float}) when is_binary(val) do
    case Float.parse(val) do
      {float, ""} ->
        {:ok, float}

      _ ->
        {:error, "invalid float"}
    end
  end
end
