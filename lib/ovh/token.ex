defmodule Ovh.Token do
  @moduledoc """
  Describe token
  """

  @type id :: String.t
  @type state :: :pending_validation | :validated
  @type t :: %__MODULE__{}

  defstruct validation_url: "", consumer_key: "", state: nil, id: ""

  @doc """
  Creates token from map returned by auth url + internal id (uuid)
  """
  def new(data, id) do
    %__MODULE__{
      validation_url: data["validationUrl"],
      consumer_key: data["consumerKey"],
      state: data["state"],
      id: id
    }
  end

  @doc """
  Set state
  """
  def set_state(token, state) when state in [:pending_validation, :validated] do
    %{token | state: state}
  end
end
