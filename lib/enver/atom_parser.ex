defmodule Enver.AtomParser do
  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, atom()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid() | invalid()
  def parse("", _) do
    {:error, "invalid atom"}
  end

  def parse(val, %{allow_nonexistent_atoms: true}) when is_binary(val) do
    {:ok, String.to_atom(val)}
  end

  def parse(val, %{allow_nonexistent_atoms: false}) when is_binary(val) do
    {:ok, String.to_existing_atom(val)}
  rescue
    _ ->
      {:error, "nonexistent atom"}
  end
end
