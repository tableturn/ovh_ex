defmodule Mix.Tasks.Ovh.Auth do
  @moduledoc """
  Task for creating OVH token
  """
  use Mix.Task

  alias Mix.Ovh

  def run(opts) do
    rules = parse_args!(opts)

    :ok = Ovh.start()

    Mix.shell().info("1 - Requesting OVH auth token with rules:")

    Enum.each(rules, fn {method, path} ->
      Mix.shell().info("\t#{method} #{path}")
    end)

    {:ok, token} = Mix.Ovh.token(rules)

    Mix.shell().info("2 - Validate token going to: #{token.validation_url}")
    Mix.shell().info("3 - Waiting for validation...")

    :ok = Ovh.Manager.wait()
    Mix.shell().info("4 - Token validated")
    Mix.shell().info("export OVH_CONSUMER_KEY=#{token.consumer_key}")
  end

  defp parse_args!(args) do
    case Enum.map(args, &parse_rule!/1) do
      [] -> usage(11)
      rules -> rules
    end
  end

  defp parse_rule!(rule) do
    case String.split(rule, " ", trim: true) do
      [method, path] when method in ["GET", "POST", "PUT", "DELETE"] ->
        {method, path}

      _ ->
        usage(11)
    end
  end

  defp usage(code) do
    Mix.shell().info("Usage: mix ovh.auth '<method> <path>' ...")
    Mix.shell().info("    <method>: one of GET, PUT, POST, DELETE")

    Mix.shell().info(
      "    <path>: API path, can use wildcards (See: https://api.ovh.com/console/)"
    )

    System.halt(code)
  end
end
