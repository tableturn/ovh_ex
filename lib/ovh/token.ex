defmodule Ovh.Token do
  @moduledoc """
  Describe token
  """

  @type state :: :pending_validation
  @type t :: %__MODULE__{}

  defstruct validation_url: "", consumer_key: "", state: nil

  @doc """
  Creates token from map returned by auth url
  """
  def new(data) do
    %__MODULE__{
      validation_url: data["validationUrl"],
      consumer_key: data["consumerKey"],
      state: data["state"]
    }
  end
end
