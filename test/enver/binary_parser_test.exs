defmodule Enver.BinaryParserTest do
  use ExUnit.Case, async: true

  @subject Enver.BinaryParser

  test "parsing returns error for invalid binary" do
    opts = %{type: :binary}
    assert @subject.parse("", opts) == {:error, "invalid binary"}
  end
end
