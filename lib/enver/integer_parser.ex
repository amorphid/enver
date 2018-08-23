defmodule Enver.IntegerParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, integer()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, opts \\ %{base: nil})

  def parse(val, %{base: base}) when is_binary(val) and base in 2..36 do
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

  def parse(val, %{} = opts) when is_binary(val) do
    parse(val, Map.put(opts, :base, 10))
  end
end
