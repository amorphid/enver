defmodule Enver.CharlistParser do
  def parse("", _) do
    {:error, :invalid_charlist}
  end

  def parse(val, _) do
    {:ok, to_charlist(val)}
  end
end
