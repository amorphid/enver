defmodule Enver.AtomParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, atom()}

  #######
  # API #
  #######

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
