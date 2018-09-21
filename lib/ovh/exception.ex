defmodule Ovh.Exception do
  @moduledoc """
  API exceptions
  """
  defexception [:code, :reason, :message]

  @doc false
  def exception({code, reason}) do
    msg = "#{code} #{reason}"
    %__MODULE__{code: code, reason: reason, message: msg}
  end

  @doc false
  def exception({code, reason, msg}) do
    msg = "#{code} #{reason} (#{msg})"
    %__MODULE__{code: code, reason: reason, message: msg}
  end
end
