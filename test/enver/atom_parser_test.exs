defmodule Enver.AtomParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.AtomParser.parse/2

  def binary_for_nonexistent_atom() do
    val =
      1..255
      |> Enum.map(fn _ -> Enum.random(1..127) end)
      |> to_string()

    # notes:
    # - we want a non nonexistent atom
    # - if no error is generated, the atom already exists, so it tries again
    # - if error is raised, then no atom equivalent exists, so val is returned
    try do
      _ = String.to_existing_atom(val)
      binary_for_nonexistent_atom()
    rescue
      error ->
        case error do
          %ArgumentError{message: "argument error"} ->
            val
          _ ->
            raise "this should not happen"
        end
    end
  end

  test "parsing returns error for invalid atom" do
    opts = %{type: :atom}
    assert @parse.("", opts) == {:error, "invalid atom"}
  end

  test "parsing returns error for nonexistent atom" do
    opts = %{type: :binary, allow_nonexistent_atoms: false}
    val = binary_for_nonexistent_atom()
    assert @parse.(val, opts) == {:error, "nonexistent atom"}
  end
end
