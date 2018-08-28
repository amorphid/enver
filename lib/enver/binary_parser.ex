defmodule Enver.BinaryParser do
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, String.t()}

  #######
  # API #
  #######

  @doc """
  Converts the given binary to an binary (aka it doesn't do much at all).

      iex(1)> Enver.BinaryParser.parse("potato", %{type: :binary})
      {:ok, "potato"}

  """
  @spec parse(val(), opts()) :: valid()
  def parse(val, %{type: :binary}) when is_binary(val) do
    {:ok, val}
  end
end
