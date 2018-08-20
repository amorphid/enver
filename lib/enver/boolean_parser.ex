defmodule Enver.BooleanParser do
  @moduledoc """
  `Enver.BinaryParser` is trying really hard to add value :P
  """

  def parse(val, _) do
    case String.downcase(val) do
      "false" ->
        {:ok, false}

      "true" ->
        {:ok, true}

      _ ->
        {:error, :invalid_boolean}
    end
  end
end
