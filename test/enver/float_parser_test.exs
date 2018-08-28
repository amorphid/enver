defmodule Enver.FloatParserTest do
  use ExUnit.Case, async: true

  @subject Enver.FloatParser

  def opts(%{} = new_opts \\ %{}) do
    Map.merge(%{type: :float}, new_opts)
  end

  describe "&parse/2" do
    test "retrieving a float" do
      opts = opts()
      assert @subject.parse("20.0", opts) == {:ok, 20.0}
    end

    test "parsing returns error for invalid float" do
      opts = opts()
      assert @subject.parse("no_digits", opts) == {:error, "invalid float"}
      assert @subject.parse("1.23trailing", opts) == {:error, "invalid float"}
      assert @subject.parse("", opts) == {:error, "invalid float"}
    end
  end
end
