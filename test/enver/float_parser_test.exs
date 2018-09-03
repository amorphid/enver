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

  describe "&validate_at_least/2" do
    test "more than" do
      assert @subject.validate_at_least(1.0, %{at_least: 0}) == :ok
    end

    test "equal to" do
      assert @subject.validate_at_least(0.0, %{at_least: 0}) == :ok
    end

    test "less than" do
      al = 0
      actual = @subject.validate_at_least(-1.0, %{at_least: al})
      expected = {:error, "float not at least: #{inspect(al)}"}
      assert actual == expected
    end

    test "not provided" do
      assert @subject.validate_at_least(1, %{}) == :ok
    end
  end

  describe "&validate_at_most/2" do
    test "less than" do
      assert @subject.validate_at_most(-1.0, %{at_most: 0}) == :ok
    end

    test "equal to" do
      assert @subject.validate_at_most(0.0, %{at_most: 0}) == :ok
    end

    test "more than" do
      am = 0
      actual = @subject.validate_at_most(1.0, %{at_most: am})
      expected = {:error, "float not at most: #{inspect(am)}"}
      assert actual == expected
    end

    test "not provided" do
      assert @subject.validate_at_most(1, %{}) == :ok
    end
  end

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

  describe "&validate_less_than/2" do
    test "less than" do
      assert @subject.validate_less_than(0, %{less_than: 1}) == :ok
    end

    test "equal to" do
      lt = 0
      actual = @subject.validate_less_than(0, %{less_than: lt})
      expected = {:error, "float not less than: #{inspect(lt)}"}
      assert actual == expected
    end

    test "greater than" do
      lt = -1
      actual = @subject.validate_less_than(0, %{less_than: lt})
      expected = {:error, "float not less than: #{inspect(lt)}"}
      assert actual == expected
    end

    test "not provided" do
      assert @subject.validate_less_than(0, %{}) == :ok
    end
  end
end
