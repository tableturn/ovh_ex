defmodule Ovh.Api do
  @moduledoc """
  https://api.ovh.com/console/
  """

  defmacro __using__(_opts) do
    quote do
      import Ovh.Api
    end
  end

  def get(path) do
    :ok
  end
end

defmodule Ovh.Api.Dedicated.Server do
  @moduledoc """
  https://api.ovh.com/console/#/dedicated/server
  """
  use Ovh.Api

  def get_all, do: get("/dedicated/server")
end
