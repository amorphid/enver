defmodule Enver.MixProject do
  use Mix.Project

  #######
  # API #
  #######

  def application() do
    [
      extra_applications: [:logger],
      mod: {Enver.Application, []}
    ]
  end

  def project() do
    [
      app: :enver,
      description: description(),
      deps: deps(),
      elixir: "~> 1.7",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "0.2.0"
    ]
  end

  ###########
  # Private #
  ###########

  defp description() do
    "An environment variable parser (think Elixir.OptionParser for environment variables)"
  end

  defp deps() do
    [
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["Apache 2.0"],
      links: %{github: "https://github.com/amorphid/enver"},
      maintainers: ["Michael Pope"]
    ]
  end
end
