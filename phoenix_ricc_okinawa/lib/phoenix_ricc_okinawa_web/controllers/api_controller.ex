defmodule PhoenixRiccOkinawaWeb.ApiController do
  use PhoenixRiccOkinawaWeb, :controller
  require Logger

  def index(conn, params) do
    render(conn, "api.json", api_data: params)
  end

  def temp(conn, postdata) do
    csv = postdata2csv(postdata)
    temp_file = ConstPhoenix.temp_file()

    File.write(temp_file, csv)

    render(conn, "temp.json", post: postdata)
  end

  def humi(conn, postdata) do
    csv = postdata2csv(postdata)
    humi_file = ConstPhoenix.humi_file()

    File.write(humi_file, csv)

    render(conn, "humi.json", post: postdata)
  end

  defp postdata2csv(postdata) do
    name = to_string(postdata["name"])
    value = to_string(postdata["value"])
    time = to_string(postdata["time"])
    csv = name <> "," <> value <> "," <> time

    csv
  end
end
