defmodule Enver.IntegerParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.IntegerParser.parse/2

  test "parsing returns error for invalid integer" do
    opts = %{type: :integer, base: 10}
    assert @parse.("no_digits", opts) == {:error, "invalid integer"}
    assert @parse.("1trailing", opts) == {:error, "invalid integer"}
    assert @parse.("1.23", opts) == {:error, "invalid integer"}
    assert @parse.("", opts) == {:error, "invalid integer"}
  end

  test "parsing returns error for invalid base" do
    base = :not_an_int_in_range_2_to_36
    actual = @parse.("99", %{type: :integer, base: base})
    expected = {:error, "invalid base: #{inspect(base)}"}
    assert actual == expected
  end
end
