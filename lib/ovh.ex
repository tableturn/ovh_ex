defmodule Ovh do
  # Drop header from README
  drop = 2
  
  doc = File.stream!("README.md")
  |> Stream.drop(drop)
  |> Enum.reduce("", &(&2 <> &1))
  
  @moduledoc doc
end
