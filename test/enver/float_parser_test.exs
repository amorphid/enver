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

  ################
  # Undocumented #
  ################

  describe "&validate_greater_than/2" do
    test "greater than" do
      assert @subject.validate_greater_than(1, %{greater_than: 0}) == :ok
    end

    test "not greater than" do
      gt = 1
      actual = @subject.validate_greater_than(1, %{greater_than: gt})
      expected = {:error, "float not greater than: #{inspect(gt)}"}
      assert actual == expected
    end

    test "not provided" do
      assert @subject.validate_greater_than(1, %{}) == :ok
    end
  end
  #
  # describe "&validate_less_than/2" do
  #   test "less than" do
  #     assert @subject.validate_less_than(0, %{less_than: 1}) == :ok
  #   end
  #
  #   test "not less than" do
  #     lt = 1
  #     actual = @subject.validate_less_than(1, %{less_than: 1})
  #     expected = {:error, "integer not less than: #{inspect(lt)}"}
  #     assert actual == expected
  #   end
  #
  #   test "not provided" do
  #     assert @subject.validate_less_than(1, %{}) == :ok
  #   end
  # end
end
