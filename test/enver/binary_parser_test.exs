defmodule Enver.BinaryParserTest do
  use ExUnit.Case, async: true

  @subject Enver.BinaryParser

  def opts(%{} = new_opts \\ %{}) do
    Map.merge(%{type: :binary}, new_opts)
  end

  describe "&parse/2" do
    test "a binary" do
      opts = opts()
      assert @subject.parse("potato", opts) == {:ok, "potato"}
    end
  end
end
