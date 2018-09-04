defmodule Enver.AtomParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, atom()}

  #######
  # API #
  #######

  @doc """
  Converts the given binary to an atom.

      iex(1)> Enver.AtomParser.parse("ok", %{type: :atom})
      {:ok, :ok}

  ## Options:

  - `:allow_nonexistent`
    - When `false`, the recommended setting, atoms that do not already exist will not be created, and an error will be returned
    - When `true`, the binary will be converted to an atom, creating a new atom if one did not already exist
    - To better understand the difference between existing & nonexistent atoms, read up on the differences betweeen `&String.to_existing_atom/1` and `&String.to_atom/1`
    - Defaults to false`
  """
  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, %{type: :atom, allow_nonexistent: true}) when is_binary(val) do
    {:ok, String.to_atom(val)}
  end

  def parse(val, %{type: :atom, allow_nonexistent: false})
      when is_binary(val) do
    {:ok, String.to_existing_atom(val)}
  rescue
    _ ->
      {:error, "nonexistent atom"}
  end

  def parse(val, %{type: :atom} = opts) when is_binary(val) do
    parse(val, Map.put(opts, :allow_nonexistent, false))
  end
end
