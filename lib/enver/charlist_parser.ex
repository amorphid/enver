defmodule Enver.CharlistParser do
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, charlist()}

  #######
  # API #
  #######

  @doc """
  Converts the given binary to an charlist.

      iex(1)> Enver.CharlistParser.parse("potato", %{type: :charlist})
      {:ok, 'potato'}
  """
  @spec parse(val(), opts()) :: valid()
  def parse(val, %{type: :charlist}) when is_binary(val) do
    {:ok, to_charlist(val)}
  end
end
