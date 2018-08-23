defmodule Enver.FloatParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.FloatParser.parse/2

  test "parsing returns error for invalid float" do
    opts = %{type: :float}
    assert @parse.("no_digits", opts) == {:error, "invalid float"}
    assert @parse.("1.23trailing", opts) == {:error, "invalid float"}
    assert @parse.("", opts) == {:error, "invalid float"}
  end
end
