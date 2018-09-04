defmodule EnverTest do
  use ExUnit.Case, async: true

  @subject Enver

  def bof() do
    %{
      fetch_app_env: &fetch_app_env/2,
      get_sys_env: &get_sys_env/0
    }
  end

  def fetch_app_env(:enver, :fetch_env) do
    {:ok, %{}}
  end

  def get_sys_env() do
    %{"MISSING_PARSE_OPTS_VAR" => "THIS_VAL_NOT_USED"}
  end

  #######
  # API #
  #######

  describe "&fetch_env/2" do
    test "is exported by Enver module" do
      name_and_arity = {:fetch_env, 2}

      actual =
        @subject.module_info()
        |> Keyword.get(:exports)
        |> Enum.filter(fn {_, _} = kv -> kv == name_and_arity end)

      expected = [name_and_arity]
      assert actual == expected
    end

    test "a missing environment variable" do
      key = "MISSING_ENVIRONMENT_VAR"
      actual = @subject.fetch_env(key, bof())
      expected = {:error, "No environment variable for key: #{inspect(key)}"}
      assert actual == expected
    end

    test "missing parse opts" do
      key = "MISSING_PARSE_OPTS_VAR"
      actual = @subject.fetch_env(key, bof())
      expected = {:error, "No parse options for key: #{inspect(key)}"}
      assert actual == expected
    end
  end

  ################
  # Undocumented #
  ################

  describe "&bag_of_functions/0" do
    test "expected values" do
      actual = @subject.bag_of_functions()

      expected = %{
        fetch_app_env: &Application.fetch_env/2,
        get_sys_env: &System.get_env/0
      }

      assert actual == expected
    end
  end

  describe "&fetch_parser/1" do
    test "atom" do
      assert @subject.fetch_parser(:atom) == {:ok, &Enver.AtomParser.parse/2}
    end

    test "binary" do
      actual = @subject.fetch_parser(:binary)
      expected = {:ok, &Enver.BinaryParser.parse/2}
      assert actual == expected
    end

    test "boolean" do
      actual = @subject.fetch_parser(:boolean)
      expected = {:ok, &Enver.BooleanParser.parse/2}
      assert actual == expected
    end

    test "charlist" do
      actual = @subject.fetch_parser(:float)
      expected = {:ok, &Enver.FloatParser.parse/2}
      assert actual == expected
    end

    test "float" do
      actual = @subject.fetch_parser(:float)
      expected = {:ok, &Enver.FloatParser.parse/2}
      assert actual == expected
    end

    test "integer" do
      actual = @subject.fetch_parser(:integer)
      expected = {:ok, &Enver.IntegerParser.parse/2}
      assert actual == expected
    end

    test "unknown" do
      type = :unknown_type
      actual = @subject.fetch_parser(type)
      expected = {:error, "No parser for type: #{inspect(type)}"}
      assert actual == expected
    end
  end
end
