defmodule EnverTest do
  use ExUnit.Case, async: true

  def bof() do
    %{
      fetch_app_env: &fetch_app_env/2,
      get_sys_env: &get_sys_env/0
    }
  end

  def fetch_app_env(:enver, :env) do
    {
      :ok,
      %{
        "BASE_2_INTEGER_VAR" => %{type: :integer, base: 2},
        "BASE_10_INTEGER_VAR" => %{type: :integer, base: 10},
        "BASE_16_INTEGER_VAR" => %{type: :integer, base: 16}
      }
    }
  end

  def get_sys_env() do
    %{
      "BASE_2_INTEGER_VAR" => "10100",
      "BASE_10_INTEGER_VAR" => "20",
      "BASE_16_INTEGER_VAR" => "14",
      "MISSING_PARSE_OPTS_VAR" => "THIS_VAL_NOT_USED"
    }
  end

  test "retrieving a base 2 integer" do
    assert Enver.env("BASE_2_INTEGER_VAR", bof()) == {:ok, 20}
  end

  test "retrieving a base 10 integer" do
    assert Enver.env("BASE_10_INTEGER_VAR", bof()) == {:ok, 20}
  end

  test "retrieving a base 16 integer" do
    assert Enver.env("BASE_16_INTEGER_VAR", bof()) == {:ok, 20}
  end

  test "retrieving an missing environment variable" do
    missing_env_var = "MISSING_ENVIRONMENT_VAR"
    actual = Enver.env(missing_env_var, bof())
    expected = {:error, {:proto_val_missing_for_key, missing_env_var}}
    assert actual == expected
  end

  test "retrieving a missing environment variable" do
    key = "MISSING_ENVIRONMENT_VAR"
    actual = Enver.env(key, bof())
    expected = {:error, {:proto_val_missing_for_key, key}}
    assert actual == expected
  end

  test "retrieving a environment variable w/ missing parse opts" do
    key = "MISSING_PARSE_OPTS_VAR"
    actual = Enver.env(key, bof())
    expected = {:error, {:parse_opts_invalid_for_key, key}}
    assert actual == expected
  end

  test "integer types are parsed w/ integer parser" do
    assert Enver.fetch_parser(:integer) == {:ok, &Enver.IntegerParser.parse/2}
  end
end
