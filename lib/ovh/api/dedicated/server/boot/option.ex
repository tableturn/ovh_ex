defmodule Ovh.Api.Dedicated.Server.Boot.Option do
  @moduledoc """
  """
  use Ovh.Api

  def get(server, boot_id), do: do_get("/dedicated/server/#{server}/boot/#{boot_id}/option")

  def get(server, boot_id, option),
    do: do_get("/dedicated/server/#{server}/boot/#{boot_id}/option/#{option}")
end
