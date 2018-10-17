defmodule Ovh.Server do
  @moduledoc """
  High level wrapper for dedicated servers
  """
  alias Ovh.Api
  alias Ovh.Ipxe

  @properties [
    :datacenter,
    :professionalUse,
    :supportLevel,
    :ip,
    :commercialRange,
    :os,
    :state,
    :serverId,
    :bootId,
    :name,
    :rescueMail,
    :reverse,
    :monitoring,
    :rack,
    :rootDevice,
    :linkSpeed
  ]

  defstruct @properties

  @type t :: %__MODULE__{}

  @doc """
  Creates struct from JSON obj
  """
  @spec new(map | nil) :: t | nil
  def new(nil), do: nil

  def new(obj) do
    s = %__MODULE__{}

    Enum.reduce(@properties, s, fn prop, acc ->
      %{acc | prop => Map.get(obj, "#{prop}")}
    end)
  end

  @doc """
  Find a server

  If arg is a string, looks by name or reverse
  If arg is a Keyword list, looks by matching server properties

  Example:

    find(rack: "XXX001")
      Returns servers in rack 'XXX001'
  """
  @spec find(String.t() | Keyword.t()) :: [t]
  def find(name_or_reverse) when is_binary(name_or_reverse) do
    try do
      name_or_reverse
      |> Api.get()
      |> new()
      |> to_list()
    rescue
      x in [Ovh.Exception] ->
        if x.code == 404 do
          reverse =
            if String.ends_with?(name_or_reverse, ".") do
              name_or_reverse
            else
              name_or_reverse <> "."
            end

          first(reverse: reverse)
        else
          stacktrace = System.stacktrace()
          reraise x, stacktrace
        end
    end
  end

  def find(props) when is_list(props) do
    "/dedicated/server"
    |> Api.get()
    |> Enum.reduce([], fn service, acc ->
      service
      |> Enum.map(&"/dedicated/server/#{&1}")
      |> Api.get()
      |> filter(props)
      |> add_non_nil(acc)
    end)
    |> Enum.map(&new/1)
  end

  @doc """
  Find first server matching props

  For consistency purpose, returns empty list or one-element list
  """
  @spec first(Keyword.t()) :: [t]
  def first(props) do
    server =
      "/dedicated/server"
      |> Api.get()
      |> Enum.find_value(
        nil,
        &("/dedicated/server/#{&1}" |> Api.get() |> filter(props))
      )
      |> new()

    if server do
      [server]
    else
      []
    end
  end

  @doc """
  Set custom ipxe script as boot
  """
  @spec set_ipxe(t, Ovh.Ipxe.t()) :: t
  def set_ipxe(server, ipxe) do
    # Get boot id for this specific server
    boot =
      "/dedicated/server/#{server.name}/boot?bootType=ipxeCustomerScript"
      |> Api.get()
      |> Enum.find_value(
        nil,
        &("/dedicated/server/#{server.name}/boot/#{&1}"
          |> Api.get()
          |> find_boot(ipxe.name))
      )

    boot_id = Map.get(boot, "bootId")
    nil = Api.put("/dedicated/server/#{server.name}", %{bootId: boot_id})
    %{server | bootId: boot_id}
  end

  @doc """
  Set ipxe boot from template

  Override existing boot if exists
  """
  @spec set_ipxe_tmpl(t, tmpl :: String.t(), ctx :: Keyword.t()) :: t()
  def set_ipxe_tmpl(server, tmpl, ctx) do
    ipxe_script = "#{tmpl}-#{server.serverId}"

    if ipxe_script in Api.get("/me/ipxeScript") do
      Api.delete("/me/ipxeScript/#{ipxe_script}")
    end

    boot =
      tmpl
      |> Ipxe.template(ctx)
      |> Map.put(:name, ipxe_script)

    _ = Ipxe.create(boot)
    set_ipxe(server, boot)
  end

  @doc """
  Reboot server
  """
  @spec reboot(t) :: :ok
  def reboot(server), do: Api.post("/dedicated/server/#{server.name}/reboot", %{})

  ###
  ### Priv
  ###
  defp filter(obj, props) do
    if match(obj, props) do
      obj
    else
      nil
    end
  end

  defp match(obj, props) when is_map(obj) do
    Enum.all?(props, fn {name, value} ->
      case Map.get(obj, "#{name}") do
        nil -> false
        ^value -> true
        _ -> false
      end
    end)
  end

  defp match(_, _), do: false

  defp find_boot(%{"kernel" => name} = boot, name), do: boot
  defp find_boot(_, _), do: nil

  defp to_list(obj), do: [obj]

  defp add_non_nil(nil, acc), do: acc
  defp add_non_nil(obj, acc), do: [obj | acc]
end
