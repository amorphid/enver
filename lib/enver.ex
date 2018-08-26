defmodule Enver do
  @moduledoc """
  Documentation for Enver.
  """

  @type bof :: map()
  @type fetch_app_env :: (:error, :env -> {:ok, map()} | :error)
  @type get_sys_env :: (-> map())
  @type invalid :: {:error, String.t()}
  @type key :: String.t()
  @type parse_opts :: map()
  @type parser :: (val(), map() -> valid() | invalid())
  @type proto_val() :: String.t()
  @type type :: atom()
  @type val :: String.t()
  @type valid :: {:ok, term()}

  #######
  # API #
  #######

  @spec fetch_env(key(), map()) :: valid() | invalid()
  def fetch_env(key, bof \\ bag_of_functions()) do
    with {:ok, proto_val} <- fetch_proto_val(key, bof.get_sys_env),
         {:ok, parse_opts} <- fetch_parse_opts(key, bof.fetch_app_env),
         {:ok, parser} <- fetch_parser(parse_opts.type),
         {:ok, _} = valid <- parser.(proto_val, parse_opts) do
      valid
    else
      {:error, _} = invalid ->
        invalid
    end
  end

  ################
  # Undocumented #
  ################

  @spec fetch_parse_opts(key(), fetch_app_env()) :: {:ok, parse_opts()} | invalid()
  def fetch_parse_opts(key, fetch_app_env) do
    case fetch_app_env.(:enver, :fetch_env) do
      {:ok, %{^key => %{type: _} = val}} ->
        {:ok, val}

      _ ->
        {:error, "No parse options for key: #{inspect(key)}"}
    end
  end

  @spec fetch_parser(type()) :: {:ok, parser()} | invalid()
  def fetch_parser(:atom), do: {:ok, &Enver.AtomParser.parse/2}

  def fetch_parser(:boolean), do: {:ok, &Enver.BooleanParser.parse/2}

  def fetch_parser(:binary), do: {:ok, &Enver.BinaryParser.parse/2}

  def fetch_parser(:charlist), do: {:ok, &Enver.CharlistParser.parse/2}

  def fetch_parser(:float), do: {:ok, &Enver.FloatParser.parse/2}

  def fetch_parser(:integer), do: {:ok, &Enver.IntegerParser.parse/2}

  def fetch_parser(type), do: {:error, "No parser for type: #{inspect(type)}"}

  @spec fetch_proto_val(key(), get_sys_env()) :: {:ok, proto_val()} | invalid
  def fetch_proto_val(key, get_sys_env) do
    case get_sys_env.() do
      %{^key => val} ->
        {:ok, val}

      _ ->
        {:error, "No environment variable for key: #{inspect(key)}"}
    end
  end

  ###########
  # Private #
  ###########

  @type bag_of_functions() :: bof()
  def bag_of_functions() do
    %{
      fetch_app_env: &Application.fetch_env/2,
      get_sys_env: &System.get_env/0
    }
  end
end
