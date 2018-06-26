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
      mod: {Ovh.App, []},
      env: [
        app_key: "miNfxN9LqMJQPjCy",
        app_secret: "",
        expires: 300_000
      ],
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.6"},
      {:cowboy, "~> 1.0"},
      {:uuid, "~> 1.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
