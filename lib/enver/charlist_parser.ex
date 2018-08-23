defmodule Enver.CharlistParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, charlist()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid() | invalid()
  def parse("", _) do
    {:error, "invalid charlist"}
  end

  def parse(val, _) when is_binary(val) do
    {:ok, to_charlist(val)}
  end
end
