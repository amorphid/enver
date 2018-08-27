defmodule Enver.CharlistParserTest do
  use ExUnit.Case, async: true

  @subject Enver.CharlistParser

  test "parsing returns error for invalid charlist" do
    opts = %{type: :charlist}
    assert @subject.parse("", opts) == {:error, "invalid charlist"}
  end
end
