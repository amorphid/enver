defmodule Enver.AtomParser do

  #######
  # API #
  #######

  def parse("", _) do
    {:error, :invalid_atom}
  end

  def parse(val, %{allow_nonexistent_atoms: true}) do
    {:ok, String.to_atom(val)}
  end

  def parse(val, %{allow_nonexistent_atoms: false}) do
    {:ok, String.to_existing_atom(val)}
  rescue
    error ->
      case error do
        %ArgumentError{message: "argument error"} when is_binary(val) ->
          {:error, :nonexistent_atom}

        _ ->
          raise error
      end
  end

  #######
  # API #
  #######
end
