defmodule Sensor.WebPost do

  require Logger

  alias Sensor.ConstNerves
  @my_name ConstNerves.my_name
  @url_temp ConstNerves.url_temp
  @url_humi ConstNerves.url_humi

  @doc """
  測定データを打ち上げ
  ## Examples
    iex> Sensor.Aht20.read_from_aht20() |> Sensor.WebPost.senddata()
    > send: 22.7 degree Celsius, 39.9 %
    :ok
  """

  def senddata({temp, nil}) do
    post(temp, @url_temp)
  end

  def senddata({nil, humi}) do
    post(humi, @url_humi)
  end

  def senddata({:ok, {temp, nil}}) do
    senddata({temp, nil})
  end

  def senddata({:ok, {temp, humi}}) do
    senddata({temp, nil})
    senddata({nil, humi})
  end



  # 指定のURLにPOSTする
  ## Parameters
  ## - val: POSTする内容
  ## - url: POSTするAPIのURL
  defp post(val, url) do
    HTTPoison.post!(url, body(val), header())
    # Logger.info("url => #{url}")
    # Logger.info("body => #{body(val)}")
  end

  # JSONデータの生成
  ## Parameters
  ## - val: POSTする内容
  defp body(val) do
    # 現在時刻を取得
    time =
      Timex.now()
      |> Timex.to_unix()

    # JSONに変換
    # Jason.encode!(%{value: %{name: @my_name, value: val, time: time}})
    Jason.encode!(%{name: @my_name, value: val, time: time})
  end

  # ヘッダの生成
  defp header() do
    [{"Content-type", "application/json"}]
  end
end
