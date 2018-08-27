defmodule Enver.BooleanParserTest do
  use ExUnit.Case, async: true

  @subject Enver.BooleanParser

  test "parsing returns error for invalid boolean" do
    opts = %{type: :boolean}
    assert @subject.parse("not_boolean", opts) == {:error, "invalid boolean"}
    assert @subject.parse("truefalse", opts) == {:error, "invalid boolean"}
    assert @subject.parse("", opts) == {:error, "invalid boolean"}
  end
end
