defmodule Ovh.Api.Dedicated.Server.Reboot do
  @moduledoc """
  https://api.ovh.com/console/#/dedicated/server/%7BserviceName%7D/reboot#POST
  """
  use Ovh.Api

  def post(server), do: do_post("/dedicated/server/#{server}/reboot", %{})
end
