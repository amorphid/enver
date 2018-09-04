defmodule Enver.AtomParserTest do
  use ExUnit.Case, async: true

  @subject Enver.AtomParser

  def binary_for_nonexistent_atom() do
    # max atom length is 255
    val =
      1..255
      |> Enum.map(fn _ -> Enum.random(?a..?z) end)
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

  def opts(new_opts \\ %{}) do
    Map.merge(%{type: :atom}, new_opts)
  end

  describe "&parse/2" do
    test "an existing atom w/ allow_nonexistent opt as false" do
      # create binary for nonexistent atom
      val_str = binary_for_nonexistent_atom()
      # creates atom by converting the value
      val_atom = String.to_atom(val_str)
      opts = opts(%{allow_nonexistent: false})
      actual = @subject.parse(val_str, opts)
      expected = {:ok, val_atom}
      assert actual == expected
    end

    test "an existing atom w/o allow_nonexistent opt" do
      # create binary for nonexistent atom
      val_str = binary_for_nonexistent_atom()
      # creates atom by converting the value
      val_atom = String.to_atom(val_str)
      opts = opts()
      actual = @subject.parse(val_str, opts)
      expected = {:ok, val_atom}
      assert actual == expected
    end

    test "a nonexisent atom w/ allow_nonexistent opt as true" do
      # create binary for nonexistent atom
      val_str = binary_for_nonexistent_atom()
      opts = opts(%{allow_nonexistent: true})
      # val should not exist yet
      :error =
        try do
          String.to_existing_atom(val_str)
        rescue
          _ -> :error
        end

      actual = @subject.parse(val_str, opts)
      # val should now exist, having been created during parsing
      val_atom = String.to_existing_atom(val_str)
      expected = {:ok, val_atom}
      assert actual == expected
    end

    test "a nonexisent atom w/ allow_nonexistent opt as false" do
      # create binary for nonexistent atom
      val_str = binary_for_nonexistent_atom()
      opts = opts(%{allow_nonexistent: false})
      # val should not exist yet
      :error =
        try do
          String.to_existing_atom(val_str)
        rescue
          _ -> :error
        end

      actual = @subject.parse(val_str, opts)
      expected = {:error, "nonexistent atom"}
      assert actual == expected
    end

    test "a nonexisent atom w/o allow_nonexistent opt" do
      # create binary for nonexistent atom
      val_str = binary_for_nonexistent_atom()
      opts = opts()
      # val should not exist yet
      :error =
        try do
          String.to_existing_atom(val_str)
        rescue
          _ -> :error
        end

      actual = @subject.parse(val_str, opts)
      expected = {:error, "nonexistent atom"}
      assert actual == expected
    end
  end
end
