defmodule Enver.CharlistParser do

  #######
  # API #
  #######

  def parse("", _) do
    {:error, "invalid charlist"}
  end

  def parse(val, _) do
    {:ok, to_charlist(val)}
  end
end
