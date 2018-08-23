defmodule Enver.IntegerParser do

  #######
  # API #
  #######

  def parse(val, opts \\ %{base: nil})

  def parse(val, %{base: base}) when base in 2..36 do
    case Integer.parse(val, base) do
      {int, ""} ->
        {:ok, int}

      _ ->
        {:error, "invalid integer"}
    end
  end

  def parse(_, %{base: base}) do
    {:error, "invalid base: #{inspect(base)}"}
  end

  def parse(val, %{} = opts) do
    parse(val, Map.put(opts, :base, 10))
  end
end
