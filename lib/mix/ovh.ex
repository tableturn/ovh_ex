defmodule Mix.Ovh do
  @moduledoc false
  @type rule :: {method :: String.t(), path :: String.t()}

  defmodule Token do
    @moduledoc false
    @type t :: %__MODULE__{}

    defstruct validation_url: "", consumer_key: ""

    def new(data) do
      %__MODULE__{
        validation_url: data["validationUrl"],
        consumer_key: data["consumerKey"]
      }
    end
  end

  defmodule Manager do
    @moduledoc false
    use GenServer

    @doc "Set token"
    def set(token, id), do: GenServer.call(__MODULE__, {:set, token, id})

    @doc "Validate token"
    def validate(id), do: GenServer.call(__MODULE__, {:validate, id})

    @doc "Wait for token to be validated"
    def wait do
      receive do
        :token_validated -> :ok
      end
    end

    ###
    ### GenServer callbacks
    ###
    def start_link(pid) do
      GenServer.start_link(__MODULE__, pid, name: __MODULE__)
    end

    def init(pid) do
      {:ok, %{pid: pid, token: nil, id: nil}}
    end

    def handle_call({:set, token, id}, _from, s) do
      {:reply, token, %{s | token: token, id: id}}
    end

    def handle_call({:validate, id}, _from, %{id: id, pid: pid} = s) do
      send(pid, :token_validated)
      {:reply, {:ok, s.token}, s}
    end

    def handle_call(_, _from, s), do: {:reply, :error, s}
  end

  defmodule Http do
    @moduledoc false
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/" do
      conn = Plug.Conn.fetch_query_params(conn)

      with token_id when is_binary(token_id) <- conn.params["id"],
           {:ok, token} = Manager.validate(token_id) do
        send_resp(conn, 200, "OK. Consumer key: #{token.consumer_key}\n")
      else
        _ ->
          send_resp(conn, 400, "MALFORMED REQUEST\n")
      end
    end

    match _ do
      send_resp(conn, 404, "NOT FOUND\n")
    end
  end

  @url_auth "https://eu.api.ovh.com/1.0/auth/credential"
  @port 3142

  @doc """
  Start callback web server, etc
  """
  @spec start() :: :ok
  def start() do
    {:ok, _} = Application.ensure_all_started(:cowboy)
    :ok = Application.load(:ovh)

    children = [
      {Manager, self()},
      {Plug.Adapters.Cowboy, scheme: :http, plug: Http, options: [port: @port]}
    ]

    {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
    :ok
  end

  @doc """
  Get a token
  """
  @spec token([rule]) :: {:ok, Token.t()} | {:error, term}
  def token(rules \\ [{"GET", "/*"}]) do
    access_rules =
      Enum.map(rules, fn {method, path} ->
        %{"method" => method, "path" => path}
      end)

    id = UUID.uuid4()
    redirection = "http://0.0.0.0:#{@port}/?id=#{id}"

    req_body = %{"accessRules" => access_rules, "redirection" => redirection}

    app_key = Confex.get_env(:ovh, :app_key, "")
    headers = [{'X-Ovh-Application', '#{app_key}'}]

    case req(:post, @url_auth, headers, req_body) do
      {:ok, {{_, 200, _}, _, body}} ->
        token =
          body
          |> Poison.decode!()
          |> Token.new()
          |> Manager.set(id)

        {:ok, token}

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
