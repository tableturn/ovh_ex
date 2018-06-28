defmodule Ovh.Api.Dedicated.Server.Boot do
  @moduledoc """
  https://api.ovh.com/console/#/dedicated/server/{serviceName}/boot#GET
  """
  use Ovh.Api

  def get(server), do: do_get("/dedicated/server/#{server}/boot")

  def get(server, boot_id), do: do_get("/dedicated/server/#{server}/boot/#{boot_id}")
end
