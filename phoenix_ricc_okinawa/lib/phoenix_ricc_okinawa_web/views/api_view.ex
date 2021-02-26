defmodule PhoenixRiccOkinawaWeb.ApiView do
  use PhoenixRiccOkinawaWeb, :view
  require Logger

  def render("api.json", %{api_data: params}) do
    %{
      params: params,
      id: 123,
      name: "nishiuchikazuma"
    }
  end

  def render("temp.json", %{post: postdata}) do
    [name, value, time] = postdata2string(postdata)

    # name = to_string(postdata["name"])
    # value = to_string(postdata["value"])
    # time = to_string(postdata["time"])
    %{
      name: name,
      value: value,
      time: time
    }
  end

  def render("humi.json", %{post: postdata}) do
    [name, value, time] = postdata2string(postdata)

    # name = postdata["name"]
    # value = postdata["value"]
    # time = postdata["time"]

    %{
      name: name,
      value: value,
      time: time
    }
   end

  defp postdata2string(postdata) do
    name = to_string(postdata["name"])
    value = to_string(postdata["value"])
    time = to_string(postdata["time"])

    [name, value, time]
  end
end
