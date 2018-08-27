defmodule Enver.BinaryParser do
  @moduledoc """
  `Enver.BinaryParser` is trying really hard to add value :P
  """

  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, String.t()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid()
  def parse(val, %{type: :binary}) when is_binary(val) do
    {:ok, val}
  end
end
