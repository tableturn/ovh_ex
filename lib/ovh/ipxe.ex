defmodule Ovh.Ipxe do
  @moduledoc """
  IPXE scripts manipulation functions
  """
  alias Ovh.Api

  defstruct name: "", description: "", script: "", file: nil

  @r_description ~r/#\s*description: (?<description>.*)/

  @type t :: %__MODULE__{}

  @doc """
  Creates ipxe script
  """
  @spec new(name :: String.t(), description :: String.t(), script :: String.t()) :: t()
  def new(name, description \\ "", script) do
    %__MODULE__{name: name, description: description, script: script}
  end

  @doc """
  Creates ipxe script from template
  """
  @spec template(tmpl_name :: String.t(), varbinds :: Keyword.t()) :: String.t()
  def template(name, varbinds) do
    [:code.priv_dir(:ovh), "ipxe", "#{name}.ipxe.eex"]
    |> Path.join()
    |> from_tmpl()
    |> bind_tmpl(varbinds)
  end

  @doc """
  List available templates
  """
  @spec templates() :: [String.t()]
  def templates() do
    [:code.priv_dir(:ovh), "ipxe", "*.ipxe.eex"]
    |> Path.join()
    |> Path.wildcard()
    |> Enum.map(&from_tmpl/1)
  end

  @doc """
  Creates custom ipxe script on OVH
  """
  @spec create(t()) :: t()
  def create(boot) do
    ret =
      Api.post("/me/ipxeScript", %{
        name: boot.name,
        description: boot.description,
        script: boot.script
      })

    case ret do
      %{"name" => _} -> boot
      err -> raise "Error creating ipxe script: #{inspect(err)}"
    end
  end

  ###
  ### Priv
  ###
  defp from_tmpl(path) do
    name = Path.basename(path, ".ipxe.eex")

    description =
      case Regex.named_captures(@r_description, File.read!(path)) do
        %{"description" => d} -> d
        _ -> ""
      end

    %__MODULE__{name: name, description: description, file: path}
  end

  defp bind_tmpl(tmpl, varbinds) do
    %{tmpl | script: EEx.eval_file(tmpl.file, varbinds)}
  end
end
