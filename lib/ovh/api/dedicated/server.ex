defmodule Ovh.Api.Dedicated.Server do
  @moduledoc """
  https://api.ovh.com/console/#/dedicated/server
  """
  use Ovh.Api

  def get_all, do: do_get("/dedicated/server")

  def get(server), do: do_get("/dedicated/server/#{server}")

  def put(server, props), do: do_put("/dedicated/server/#{server}", props)
end
