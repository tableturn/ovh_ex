defmodule Ovh.Api.Dedicated.Server.Boot.Option do
  @moduledoc """
  https://api.ovh.com/console/#/dedicated/server/{serviceName}/boot/{bootId}/option#GET
  """
  use Ovh.Api

  def get(server, boot_id), do: do_get("/dedicated/server/#{server}/boot/#{boot_id}/option")

  def get(server, boot_id, option),
    do: do_get("/dedicated/server/#{server}/boot/#{boot_id}/option/#{option}")
end
