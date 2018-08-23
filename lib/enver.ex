defmodule Enver do
  @moduledoc """
  Documentation for Enver.
  """

  #######
  # API #
  #######

  def env(key, bof \\ bag_of_functions()) do
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

  def fetch_parse_opts(key, fetch_app_env) do
    case fetch_app_env.(:enver, :env) do
      {:ok, %{^key => %{type: _} = val}} ->
        {:ok, val}

      _ ->
        {:error, "No parse options for key: #{inspect(key)}"}
    end
  end

  def fetch_parser(:atom), do: {:ok, &Enver.AtomParser.parse/2}

  def fetch_parser(:boolean), do: {:ok, &Enver.BooleanParser.parse/2}

  def fetch_parser(:binary), do: {:ok, &Enver.BinaryParser.parse/2}

  def fetch_parser(:charlist), do: {:ok, &Enver.CharlistParser.parse/2}

  def fetch_parser(:float), do: {:ok, &Enver.FloatParser.parse/2}

  def fetch_parser(:integer), do: {:ok, &Enver.IntegerParser.parse/2}

  def fetch_parser(type), do: {:error, "No parser for type: #{inspect(type)}"}

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

  def bag_of_functions() do
    %{
      fetch_app_env: &Application.fetch_env/2,
      get_sys_env: &System.get_env/0
    }
  end
end
