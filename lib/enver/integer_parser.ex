defmodule Enver.IntegerParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, integer()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, %{type: :integer} = opts)
      when is_binary(val) and is_map(opts) do
    with :ok <- validate_base(opts),
         {:ok, int} = maybe_valid <- parse_integer(val, opts),
         :ok <- validate_greater_than(int, opts),
         :ok <- validate_less_than(int, opts),
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
  @spec parse_integer(val(), opts()) :: valid() | invalid()
  def parse_integer(val, %{base: base}) do
    case Integer.parse(val, base) do
      {int, ""} ->
        {:ok, int}

      _ ->
        {:error, "invalid integer"}
    end
  end

  def parse_integer(val, %{} = opts) when is_binary(val) do
    parse(val, Map.put(opts, :base, 10))
  end

  @doc false
  @spec validate_base(opts()) :: :ok | invalid()
  def validate_base(%{base: base}) when base in 2..36, do: :ok

  def validate_base(%{base: base}) do
    {:error, "invalid base: #{inspect(base)}"}
  end

  def validate_base(%{} = _), do: :ok

  @doc false
  @spec validate_greater_than(integer(), opts()) :: :ok | invalid()
  def validate_greater_than(int, %{greater_than: gt}) when is_integer(gt) do
    if int > gt do
      :ok
    else
      {:error, "integer not greater than: #{inspect(gt)}"}
    end
  end

  def validate_greater_than(_, %{greater_than: gt}) do
    {:error, "invalid greater_than: #{inspect(gt)}"}
  end

  def validate_greater_than(int, %{} = opts) do
    validate_greater_than(int, Map.put(opts, :greater_than, int - 1))
  end

  @doc false
  @spec validate_less_than(integer(), opts()) :: :ok | invalid()
  def validate_less_than(int, %{less_than: lt}) when is_integer(lt) do
    if int < lt do
      :ok
    else
      {:error, "integer not less than: #{inspect(lt)}"}
    end
  end

  def validate_less_than(_, %{less_than: lt}) do
    {:error, "invalid less_than: #{inspect(lt)}"}
  end

  def validate_less_than(int, %{} = opts) do
    validate_less_than(int, Map.put(opts, :less_than, int + 1))
  end
end
