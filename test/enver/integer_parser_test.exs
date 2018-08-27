defmodule Enver.IntegerParserTest do
  use ExUnit.Case, async: true

  @subject Enver.IntegerParser

  def opts(%{} = new_opts) do
    Map.merge(%{type: :integer}, new_opts)
  end

  #######
  # API #
  #######

  describe "&parse/2" do
    test "base 2 integer" do
      opts = opts(%{base: 2})
      assert @subject.parse("10100", opts) == {:ok, 20}
    end

    test "base 10" do
      opts = opts(%{base: 10})
      assert @subject.parse("20", opts) == {:ok, 20}
    end

    test "base 16" do
      opts = opts(%{base: 16})
      assert @subject.parse("14", opts) == {:ok, 20}
    end

    test "integer is invalid string" do
      opts = opts(%{base: 10})
      assert @subject.parse("no_digits", opts) == {:error, "invalid integer"}
      assert @subject.parse("1trailing", opts) == {:error, "invalid integer"}
      assert @subject.parse("1.23", opts) == {:error, "invalid integer"}
      assert @subject.parse("", opts) == {:error, "invalid integer"}
    end
  end

  ################
  # Undocumented #
  ################

  describe "&validate_base/2" do
    test "in range" do
      assert @subject.validate_base(%{base: 10}) == :ok
    end

    test "not in range" do
      base = :not_an_int_in_range_2_to_36
      actual = @subject.validate_base(%{base: base})
      expected = {:error, "invalid base: #{inspect(base)}"}
      assert actual == expected
    end

    test "not provided" do
      assert @subject.validate_base(%{}) == :ok
    end
  end

  describe "&validate_greater_than/2" do
    test "greater than" do
      assert @subject.validate_greater_than(1, %{greater_than: 0}) == :ok
    end

    test "not greater than" do
      gt = 1
      actual = @subject.validate_greater_than(1, %{greater_than: gt})
      expected = {:error, "integer not greater than: #{inspect(gt)}"}
      assert actual == expected
    end

    test "not provided" do
      assert @subject.validate_greater_than(1, %{}) == :ok
    end
  end
end
