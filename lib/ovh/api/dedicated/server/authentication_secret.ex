defmodule Ovh.Api.Dedicated.Server.AuthenticationSecret do
  @moduledoc """
  https://api.ovh.com/console/#/dedicated/server/%7BserviceName%7D/authenticationSecret#POST
  """
  use Ovh.Api

  def post(server), do: do_post("/dedicated/server/#{server}/authenticationSecret", %{})
end
