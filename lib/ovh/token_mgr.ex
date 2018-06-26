defmodule Ovh.TokenMgr do
  @moduledoc """
  Manage token
  """
  require Logger

  @expires 60_000

  defstruct tokens: %{}, timers: %{}
  
  @doc false
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {Agent, :start_link, [fn -> %__MODULE__{} end, [name: __MODULE__]]}
    }
  end

  @doc """
  Register token
  """
  @spec register(Ovh.Token.t) :: Ovh.Token.t
  def register(token) do
    Agent.get_and_update(__MODULE__, fn s ->
      {:ok, tref} = :timer.apply_after(@expires, __MODULE__, :expires, [token.id])
      s = %{
        tokens: Map.put(s.tokens, token.id, token),
        timers: Map.put(s.timers, token.id, tref)
      }
      {token, s}
    end)
  end

  @doc """
  Validate a token
  """
  @spec validate(Ovh.Token.id) :: Ovh.Token.t
  def validate(id) do
    Agent.get_and_update(__MODULE__, fn s ->
      case Map.get(s.tokens, id, nil) do
        nil ->
          {nil, s}
        t ->
          :timer.cancel(Map.get(s.timers, id))
          timers = Map.delete(s.timers, id)
          token = Ovh.Token.set_state(t, :validated)
          s = %{
            s |
            tokens: Map.put(s.tokens, token.id, token),
            timers: timers
          }
          {token, s}
      end
    end)
  end

  @doc """
  Expires a token if not validated
  """
  @spec expires(Ovh.Token.id) :: :ok
  def expires(id) do
    Agent.update(__MODULE__, fn s ->
      Logger.debug(fn -> "EXPIRES token #{id}" end)
      %{
        tokens: Map.delete(s.tokens, id),
        timers: Map.delete(s.timers, id)
    }
    end)
  end
end
