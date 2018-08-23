defmodule Enver.BinaryParser do
  @moduledoc """
  `Enver.BinaryParser` is trying really hard to add value :P
  """

  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, String.t()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid() | invalid()
  def parse("", _) do
    {:error, "invalid binary"}
  end

  def parse(val, _) when is_binary(val) do
    {:ok, val}
  end
end
