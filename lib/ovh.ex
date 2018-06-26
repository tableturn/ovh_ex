defmodule Ovh do
  @moduledoc """
  OVH API wrapper
  """

  @url_auth "https://eu.api.ovh.com/1.0/auth/credential"

  @doc """
  Get a token
  """
  @spec token() :: {:ok, {id :: String.t, redirect_url :: String.t}} | {:error, term}
  def token() do
    id = UUID.uuid4()
    redirection = Application.get_env(:ovh, :redirection, "")
    req_body = %{
      "accessRules" => [
        %{
          "method" => "GET",
          "path" => "/*"
        }
      ],
      "redirection" => "#{redirection}?id=#{id}"
    }

    app_key = Application.get_env(:ovh, :app_key, "")
    headers = [{'X-Ovh-Application', '#{app_key}'}]

    case req(:post, @url_auth, headers, req_body) do
      {:ok, {{_, 200, _}, _, body}} ->
        token = body
        |> Poison.decode!()
        |> Ovh.Token.new(id)
        _token = Ovh.TokenMgr.register(token)
        
        {:ok, {id, token.validation_url}}
        
      {:ok, {{_, code, err}, _, _}} ->
        {:error, {code, err}}

      {:error, err} ->
        {:error, err}
    end
  end

  ###
  ### Priv
  ###
  defp req(method, url, headers, body) do
    req_body = Poison.encode!(body)
    req = {'#{url}', headers, 'application/json', '#{req_body}'}
    :httpc.request(method, req, [timeout: 5_000], [])
  end
end
