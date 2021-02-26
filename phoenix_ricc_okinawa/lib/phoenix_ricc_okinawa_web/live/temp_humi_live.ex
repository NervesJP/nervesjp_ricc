defmodule PhoenixRiccOkinawaWeb.TempHumiLive do
  # use Phoenix.LiveView
  use PhoenixRiccOkinawaWeb, :live_view
  # require Logger

  def mount(_param, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :refresh, 1_000)
    end

    socket = assign_stats(socket)

    {:ok, socket}
  end

  def handle_info(:refresh, socket) do
    Process.send_after(self(), :refresh, 1_000)

    socket = assign_stats(socket)

    {:noreply, socket}
  end

  defp assign_stats(socket) do
    temp = File.read!(ConstPhoenix.temp_file())
    humi = File.read!(ConstPhoenix.humi_file())

    assign(
      socket,
      temp: temp,
      humi: humi
    )
  end
end
