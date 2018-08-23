defmodule Enver.BooleanParser do
  @moduledoc """
  `Enver.BinaryParser` is trying really hard to add value :P
  """

  #######
  # API #
  #######

  def parse(val, _) do
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
