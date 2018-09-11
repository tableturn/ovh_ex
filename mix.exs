defmodule Ovh.MixProject do
  use Mix.Project

  def project do
    [
      app: :ovh,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      aliases: [
        compile: ["format", "compile", "credo"]
      ],
      deps: deps(),
      package: package(),
      description: description(),

      # Docs
      name: "ovh.ex",
      soruce_url: "https://github.com/the-missing-link/ovh_ex",
      homepage_url: "https://github.com/the-missing-link/ovh_ex",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [],
      extra_applications: [:logger, :ssl]
    ]
  end

  defp package do
    [
      name: :ovh,
      maintainers: ["Jean Parpaillon"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/the-missing-link/ovh_ex"
      }
    ]
  end

  defp description do
    """
    ovh.ex is a wrapper for OVH API
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dev and test
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false},
      # Only dev
      {:plug, "~> 1.6", only: [:dev]},
      {:cowboy, "~> 1.0", only: [:dev]},
      {:uuid, "~> 1.1", only: [:dev]},
      {:earmark, "~> 1.2", only: :dev, runtime: false},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      # All envs
      {:confex, "~> 3.3"},
      {:poison, "~> 3.1"}
    ]
  end

  defp docs do
    [
      main: "Ovh",
      source_url: "https://github.com/the-missing-link/ovh_ex",
      extras: ["README.md"]
    ]
  end
end
