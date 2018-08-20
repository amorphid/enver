defmodule Enver.BinaryParser do
  @moduledoc """
  `Enver.BinaryParser` is trying really hard to add value :P
  """

  def parse("", _) do
    {:error, :invalid_binary}
  end

  def parse(val, _) do
    {:ok, val}
  end
end
