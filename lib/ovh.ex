defmodule Ovh do
  @moduledoc """
  OVH API wrapper
  """

  @url_auth "https://eu.api.ovh.com/1.0/auth/credential"

  @doc """
  Get a token
  """
  @spec token() :: {:ok, Ovh.Token.t} | {:error, term}
  def token() do
    req_body = %{
      "accessRules" => [ %{
                           "method" => "GET",
                           "path" => "/*"
                         }
                       ],
      "redirection" => "http://api.ovh.com"
    }
    |> Poison.encode!()
    req = {@url_auth,
           [{'X-Ovh-Application', Application.get_env(:ovh, :app_key, "")}],
           'application/json', req_body
    }
    case :httpc.request(:post, req, [], []) do
      {:ok, {{_, 200, _}, _, body}} ->
        body
        |> Poison.decode!()
        |> Ovh.Token.new()
      {:ok, {{_, code, err}, _, _}} ->
        {:error, {code, err}}
      {:error, err} ->
        {:error, err}
    end
  end
end
