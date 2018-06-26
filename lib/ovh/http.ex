defmodule Ovh.Http do
  @moduledoc """
  HTTP endpoint
  """
  use Plug.Router

  require Logger

  plug :match
  plug :dispatch
  
  get "/" do
    conn = Plug.Conn.fetch_query_params(conn)
    with token_id when is_binary(token_id) <- conn.params["id"] do
      _token = Ovh.TokenMgr.validate(token_id)
      Logger.debug("TOKEN #{token_id} succesfully validated")
      send_resp(conn, 200, "OK\n")
    else
      _ ->
        send_resp(conn, 400, "MALFORMED REQUEST\n")
    end
  end

  match _ do
    send_resp(conn, 404, "NOT FOUND\n")
  end
end
