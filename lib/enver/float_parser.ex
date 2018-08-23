defmodule Enver.FloatParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, float()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, _) when is_binary(val) do
    case Float.parse(val) do
      {float, ""} ->
        {:ok, float}

      _ ->
        {:error, "invalid float"}
    end
  end
end
