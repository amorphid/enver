defmodule Enver.FloatParser do
  def parse(val, _) do
    case Float.parse(val) do
      {float, ""} ->
        {:ok, float}

      _ ->
        {:error, :invalid_float}
    end
  end
end
