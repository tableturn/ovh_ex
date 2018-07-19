defmodule Ovh.Api do
  @moduledoc """
  https://api.ovh.com/console/
  """
  require Logger

  import Ovh.Api.Helpers

  defmacro __using__(_opts) do
    quote do
      import Ovh.Api.Helpers
    end
  end

  @type api_return :: :ok | Poison.Parser.t()
  @type api_input :: Poison.Encoder.t()

  @doc """
  GET

  Raise Ovh.Exception if code != 200
  """
  @spec get(Path.t(), :httpc.http_options(), :httpc.options()) :: api_return
  def get(path, http_opts \\ [], opts \\ []), do: do_get(path, http_opts, opts)

  @doc """
  PUT

  Raise Ovh.Exception if code != 200
  """
  @spec put(Path.t(), api_input, :httpc.http_options(), :httpc.options()) :: api_return
  def put(path, props, http_opts \\ [], opts \\ []), do: do_put(path, props, http_opts, opts)

  @doc """
  POST

  Raise Ovh.Exception if code != 200
  """
  @spec post(Path.t(), api_input, :httpc.http_options(), :httpc.options()) :: api_return
  def post(path, props, http_opts \\ [], opts \\ []), do: do_post(path, props, http_opts, opts)

  @doc """
  DELETE

  Raise Ovh.Exception if code != 200
  """
  @spec delete(Path.t()) :: api_return
  def delete(path, http_opts \\ [], opts \\ []), do: do_delete(path, http_opts, opts)
end
