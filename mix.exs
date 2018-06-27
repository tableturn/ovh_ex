defmodule Ovh.MixProject do
  use Mix.Project

  def project do
    [
      app: :ovh,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [],
      extra_applications: [:logger, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Only dev
      {:plug, "~> 1.6", only: [:dev]},
      {:cowboy, "~> 1.0", only: [:dev]},
      {:uuid, "~> 1.1", only: [:dev]},
      # All envs
      {:confex, "~> 3.3"},
      {:poison, "~> 3.1"}
    ]
  end
end
