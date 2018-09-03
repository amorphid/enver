defmodule Enver.FloatParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, float()}

  #######
  # API #
  #######

  @doc """
  Converts the given binary to an float.

      iex(1)> Enver.FloatParser.parse("1.23", %{type: :float})
      {:ok, 1.23}
  """
  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, %{type: :float} = opts) when is_binary(val) do
    with {:ok, float} = maybe_valid <- parse_float(val),
         :ok <- validate_greater_than(float, opts),
         valid <- maybe_valid do
      valid
    else
      {:error, _} = invalid ->
        invalid
    end
  end

  ################
  # Undocumented #
  ################

  @doc false
  @spec parse_float(val()) :: valid() | invalid()
  def parse_float(val) when is_binary(val) do
    case Float.parse(val) do
      {float, ""} ->
        {:ok, float}

      _ ->
        {:error, "invalid float"}
    end
  end

  @doc false
  @spec validate_at_least(float(), opts()) :: :ok | invalid() 
  def validate_at_least(float, %{at_least: al})
      when is_float(al) or is_integer(al) do
    if float >= al do
      :ok
    else
      {:error, "float not at least: #{inspect(al)}"}
    end
  end

  def validate_at_least(_, %{at_least: al}) do
    {:error, "invalid at_least: #{inspect(al)}"}
  end

  def validate_at_least(float, %{} = opts) do
    validate_at_least(float, Map.put(opts, :at_least, float - 1))
  end

  @doc false
  @spec validate_greater_than(float(), opts()) :: :ok | invalid()
  def validate_greater_than(float, %{greater_than: gt})
      when is_float(gt) or is_integer(gt) do
    if float > gt do
      :ok
    else
      {:error, "float not greater than: #{inspect(gt)}"}
    end
  end

  def validate_greater_than(_, %{greater_than: gt}) do
    {:error, "invalid greater_than: #{inspect(gt)}"}
  end

  def validate_greater_than(float, %{} = opts) do
    validate_greater_than(float, Map.put(opts, :greater_than, float - 1))
  end
end
