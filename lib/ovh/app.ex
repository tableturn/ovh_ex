defmodule Ovh.App do
  @moduledoc """
  App entry point
  """

  @doc false
  def start(_type, _args) do
    children =
      case Application.get_env(:ovh, :http, false) do
        {_ip, port} ->
          [{Plug.Adapters.Cowboy, scheme: :http, plug: Ovh.Http, options: [port: port]}]
        _ ->
          []
      end
    children = children ++ [
      {Ovh.TokenMgr, []}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
