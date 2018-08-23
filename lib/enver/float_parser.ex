defmodule Enver.FloatParser do

  #######
  # API #
  #######

  def parse(val, _) do
    case Float.parse(val) do
      {float, ""} ->
        {:ok, float}

      _ ->
        {:error, "invalid float"}
    end
  end
end
