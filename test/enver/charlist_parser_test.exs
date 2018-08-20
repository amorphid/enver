defmodule Enver.CharlistParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.CharlistParser.parse/2

  test "parsing returns error for invalid binary" do
    opts = %{type: :charlist}
    assert @parse.("", opts) == {:error, :invalid_charlist}
  end
end
