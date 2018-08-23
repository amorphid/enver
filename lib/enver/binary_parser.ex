defmodule Enver.BinaryParser do
  @moduledoc """
  `Enver.BinaryParser` is trying really hard to add value :P
  """

  #######
  # API #
  #######

  def parse("", _) do
    {:error, "invalid binary"}
  end

  def parse(val, _) do
    {:ok, val}
  end
end
