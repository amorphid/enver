defmodule Enver.BooleanParserTest do
  use ExUnit.Case, async: true

  @subject Enver.BooleanParser

  def opts(%{} = new_opts \\ %{}) do
    Map.merge(%{type: :boolean}, new_opts)
  end

  describe "&parse/2" do
    test "retrieving a lowercase boolean" do
      opts = opts()
      assert @subject.parse("true", opts) == {:ok, true}
      assert @subject.parse("false", opts) == {:ok, false}
    end

    test "retrieving a mixed case boolean" do
      opts = opts()
      assert @subject.parse("True", opts) == {:ok, true}
      assert @subject.parse("TruE", opts) == {:ok, true}
      assert @subject.parse("False", opts) == {:ok, false}
      assert @subject.parse("FaLsE", opts) == {:ok, false}
    end

    test "retrieving a upcase boolean" do
      opts = opts()
      assert @subject.parse("TRUE", opts) == {:ok, true}
      assert @subject.parse("FALSE", opts) == {:ok, false}
    end

    test "parsing returns error for invalid boolean" do
      opts = %{type: :boolean}
      assert @subject.parse("not_boolean", opts) == {:error, "invalid boolean"}
      assert @subject.parse("truefalse", opts) == {:error, "invalid boolean"}
      assert @subject.parse("", opts) == {:error, "invalid boolean"}
    end
  end
end
