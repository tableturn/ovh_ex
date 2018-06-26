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
      env: [
        app_key: "miNfxN9LqMJQPjCy",
        app_secret: ""
      ],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"}
    ]
  end
end
