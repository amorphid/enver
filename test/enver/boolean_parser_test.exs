defmodule Enver.BooleanParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.BooleanParser.parse/2

  test "parsing returns error for invalid boolean" do
    opts = %{type: :boolean}
    assert @parse.("not_boolean", opts) == {:error, "invalid boolean"}
    assert @parse.("truefalse", opts) == {:error, "invalid boolean"}
    assert @parse.("", opts) == {:error, "invalid boolean"}
  end
end
