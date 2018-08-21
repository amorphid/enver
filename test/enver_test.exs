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
        "BASE_16_INTEGER_VAR" => %{type: :integer, base: 16},
        "BASE_UNDECLARED_INTEGER_VAR" => %{type: :integer},
        "BOOLEAN_FALSE_VAR" => %{type: :boolean},
        "BOOLEAN_MIXED_CASE_VAR" => %{type: :boolean},
        "BOOLEAN_TRUE_VAR" => %{type: :boolean},
        "BOOLEAN_UPCASE_VAR" => %{type: :boolean},
        "CHARLIST_VAR" => %{type: :charlist},
        "FLOAT_VAR" => %{type: :float},
        "UTF8_BINARY_VAR" => %{type: :binary}
      }
    }
  end

  def get_sys_env() do
    %{
      "BASE_2_INTEGER_VAR" => "10100",
      "BASE_10_INTEGER_VAR" => "20",
      "BASE_16_INTEGER_VAR" => "14",
      "BASE_UNDECLARED_INTEGER_VAR" => "20",
      "BOOLEAN_FALSE_VAR" => "false",
      "BOOLEAN_MIXED_CASE_VAR" => "False",
      "BOOLEAN_TRUE_VAR" => "true",
      "BOOLEAN_UPCASE_VAR" => "TRUE",
      "CHARLIST_VAR" => "ICH_BIN_EIN_CHARLIST",
      "FLOAT_VAR" => "20.0",
      "MISSING_PARSE_OPTS_VAR" => "THIS_VAL_NOT_USED",
      "UTF8_BINARY_VAR" => "ICH_BIN_EIN_BINARY"
    }
  end

  def binary_for_nonexistent_atom() do
    val =
      1..255
      |> Enum.map(fn _ -> Enum.random(1..127) end)
      |> to_string()

    # notes:
    # - we want a non nonexistent atom
    # - if no error is generated, the atom already exists, so it tries again
    # - if error is raised, then no atom equivalent exists, so val is returned
    try do
      _ = String.to_existing_atom(val)
      binary_for_nonexistent_atom()
    rescue
      error ->
        case error do
          %ArgumentError{message: "argument error"} ->
            val
          _ ->
            raise "this should not happen"
        end
    end
  end

  @tag :potato
  test "retrieving a existing_atom" do
    val_str = binary_for_nonexistent_atom()
    val_atom = String.to_atom(val_str) # creates atom
    bof = %{
      fetch_app_env: fn (:enver, :env) ->
        {
          :ok,
          %{"EXISTING_ATOM" => %{type: :atom, allow_nonexistent_atoms: false}}
        }
      end,
      get_sys_env: fn ->
        %{"EXISTING_ATOM" => val_str}
      end
    }
    actual = Enver.env("EXISTING_ATOM", bof)
    expected = {:ok, val_atom}
    assert actual == expected
  end

  test "retrieving a nonexistent_atom" do
    val = binary_for_nonexistent_atom()
    bof = %{
      fetch_app_env: fn (:enver, :env) ->
        {
          :ok,
          %{"NONEXISTENT_ATOM" => %{type: :atom, allow_nonexistent_atoms: true}}
        }
      end,
      get_sys_env: fn ->
        %{"NONEXISTENT_ATOM" => val}
      end
    }
    actual = Enver.env("NONEXISTENT_ATOM", bof) # converts nonexistent val
    expected = {:ok, String.to_existing_atom(val)} # val should now exist
    assert actual == expected
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

  test "retrieving a false boolean" do
    assert Enver.env("BOOLEAN_FALSE_VAR", bof()) == {:ok, false}
  end

  test "retrieving a mixed case boolean" do
    assert Enver.env("BOOLEAN_MIXED_CASE_VAR", bof()) == {:ok, false}
  end

  test "retrieving a true boolean" do
    assert Enver.env("BOOLEAN_TRUE_VAR", bof()) == {:ok, true}
  end

  test "retrieving a upcase boolean" do
    assert Enver.env("BOOLEAN_UPCASE_VAR", bof()) == {:ok, true}
  end

  test "retrieving a integer w/ undeclared base defaults to base 10" do
    assert Enver.env("BASE_UNDECLARED_INTEGER_VAR", bof()) == {:ok, 20}
  end

  test "retrieving a float" do
    assert Enver.env("FLOAT_VAR", bof()) == {:ok, 20.0}
  end

  test "retrieving a UTF8 binary" do
    assert Enver.env("UTF8_BINARY_VAR", bof()) == {:ok, "ICH_BIN_EIN_BINARY"}
  end

  test "retrieving a charlist" do
    assert Enver.env("CHARLIST_VAR", bof()) == {:ok, 'ICH_BIN_EIN_CHARLIST'}
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

  test "atom types are parsed w/ atom parser" do
    assert Enver.fetch_parser(:atom) == {:ok, &Enver.AtomParser.parse/2}
  end

  test "binary types are parsed w/ binary parser" do
    assert Enver.fetch_parser(:binary) == {:ok, &Enver.BinaryParser.parse/2}
  end

  test "boolean types are parsed w/ binary parser" do
    assert Enver.fetch_parser(:boolean) == {:ok, &Enver.BooleanParser.parse/2}
  end

  test "float types are parsed w/ float parser" do
    assert Enver.fetch_parser(:integer) == {:ok, &Enver.IntegerParser.parse/2}
  end

  test "integer types are parsed w/ integer parser" do
    assert Enver.fetch_parser(:integer) == {:ok, &Enver.IntegerParser.parse/2}
  end
end
