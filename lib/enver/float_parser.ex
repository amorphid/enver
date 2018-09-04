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
         :ok <- validate_at_least(float, opts),
         :ok <- validate_at_most(float, opts),
         :ok <- validate_greater_than(float, opts),
         :ok <- validate_less_than(float, opts),
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
  @spec validate_at_most(float(), opts()) :: :ok | invalid()
  def validate_at_most(float, %{at_most: am})
      when is_float(am) or is_integer(am) do
    if float <= am do
      :ok
    else
      {:error, "float not at most: #{inspect(am)}"}
    end
  end

  def validate_at_most(_, %{at_most: am}) do
    {:error, "invalid at_most: #{inspect(am)}"}
  end

  def validate_at_most(float, %{} = opts) do
    validate_at_most(float, Map.put(opts, :at_most, float + 1))
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

  @doc false
  @spec validate_less_than(float(), opts()) :: :ok | invalid()
  def validate_less_than(float, %{less_than: lt})
      when is_float(lt) or is_integer(lt) do
    if float < lt do
      :ok
    else
      {:error, "float not less than: #{inspect(lt)}"}
    end
  end

  def validate_less_than(_, %{less_than: lt}) do
    {:error, "invalid less_than: #{inspect(lt)}"}
  end

  def validate_less_than(float, %{} = opts) do
    validate_less_than(float, Map.put(opts, :less_than, float + 1))
  end
end
