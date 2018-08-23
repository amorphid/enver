defmodule Enver.BinaryParserTest do
  use ExUnit.Case, async: true

  @parse &Enver.BinaryParser.parse/2

  test "parsing returns error for invalid binary" do
    opts = %{type: :binary}
    assert @parse.("", opts) == {:error, "invalid binary"}
  end
end
