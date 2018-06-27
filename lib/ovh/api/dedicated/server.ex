defmodule Ovh.Api.Dedicated.Server do
  @moduledoc """
  https://api.ovh.com/console/#/dedicated/server
  """
  use Ovh.Api

  def get_all, do: get("/dedicated/server")
end
