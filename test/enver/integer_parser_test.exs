defmodule Enver.IntegerParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.IntegerParser.parse/2

  test "parsing defaults to base 10" do
    assert @parse.("99", %{type: :integer}) == {:ok, 99}
  end

  test "parsing returns error for invalid base" do
    base = :not_an_int_in_range_2_to_36
    actual = @parse.("99", %{type: :integer, base: base})
    expected = {:error, {:invalid_base, base}}
    assert actual == expected
  end
end
