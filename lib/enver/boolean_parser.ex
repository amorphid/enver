defmodule Enver.BooleanParser do
  @moduledoc """
  `Enver.BinaryParser` is trying really hard to add value :P
  """

  @type invalid :: Enver.invalid()
  @type opts :: Enver.parse_opts()
  @type val :: Enver.val()
  @type valid :: {:ok, boolean()}

  #######
  # API #
  #######

  @spec parse(val(), opts()) :: valid() | invalid()
  def parse(val, %{type: :boolean}) when is_binary(val) do
    case String.downcase(val) do
      "false" ->
        {:ok, false}

      "true" ->
        {:ok, true}

      _ ->
        {:error, "invalid boolean"}
    end
  end
end
