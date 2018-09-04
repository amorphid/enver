defmodule Enver.CharlistParserTest do
  use ExUnit.Case, async: true

  @subject Enver.CharlistParser

  def opts(%{} = new_opts \\ %{}) do
    Map.merge(%{type: :charlist}, new_opts)
  end

  test "parsing returns error for invalid charlist" do
    opts = opts()
    assert @subject.parse("potato", opts) == {:ok, 'potato'}
  end
end
