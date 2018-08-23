defmodule Enver.CharlistParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.CharlistParser.parse/2

  test "parsing returns error for invalid charlist" do
    opts = %{type: :charlist}
    assert @parse.("", opts) == {:error, "invalid charlist"}
  end
end
