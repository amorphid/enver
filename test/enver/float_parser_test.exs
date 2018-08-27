defmodule Enver.FloatParserTest do
  use ExUnit.Case, async: true

  @subject Enver.FloatParser

  test "parsing returns error for invalid float" do
    opts = %{type: :float}
    assert @subject.parse("no_digits", opts) == {:error, "invalid float"}
    assert @subject.parse("1.23trailing", opts) == {:error, "invalid float"}
    assert @subject.parse("", opts) == {:error, "invalid float"}
  end
end
