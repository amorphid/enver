defmodule EnverTest do
  use ExUnit.Case
  doctest Enver

  test "greets the world" do
    assert Enver.hello() == :world
  end
end
