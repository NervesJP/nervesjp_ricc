defmodule Sensor.Mcp9808 do
  @moduledoc """
  Documentation for `Mcp9808`.
  温湿度センサ MCP9808 の制御モジュール
  """

  # 関連するライブラリを読み込み
  require Logger     # ログ出力用
  alias Circuits.I2C # 以降 I2C.func の形式で func 関数を呼べるようになる

  # 定数
  alias Sensor.ConstNerves
  @i2c_bus ConstNerves.i2c_bus
  @i2c_addr ConstNerves.i2c_addr
  @i2c_delay ConstNerves.i2c_delay_ms

  @doc """
  温度を表示
  ## Examples
    iex> Sensor.Mcp9808.print_temp
    > temp (degree Celsius)
    22.1
    :ok
  """
  def print_temp() do
    IO.puts(" > temp: #{temp()} (degree Celsius)")
  end

  # 温度の値を取得
  defp temp() do
    # MCP9808 から読み出し
    {:ok, {temp, _humi}} = read_mcp9808()
    temp
  end

  @doc """
  MCP9808 から温度を取得
  ## Examples
    iex> Sensor.Mcp9808.read_mcp9808
    {:ok, {22.4, nil}} # MCP9808 は湿度計測が無いので返値の2番目は常に nil
    {:error, "Sensor is not connected"}
  """
  def read_mcp9808() do
    # I2Cを開く
    {:ok, ref} = I2C.open(@i2c_bus)

    # MCP9808 を初期化する
    # I2C.write(ref, @i2c_addr, <<0b1000, 0b11>>)
    #   分解能の制御（デフォルトの場合で良いなら write 不要）
    #   変更したい場合は 0b00001000 レジスタに以下の値を書く…
    #     00: +0.5°C (Tconv = 30 ms typical)
    #     01: +0.25°C (Tconv = 65 ms typical)
    #     10: +0.125°C (Tconv = 130 ms typical)
    #     11: +0.0625°C (power-up default, Tconv = 250 ms typical)
    # 処理完了まで一定時間待機
    Process.sleep(@i2c_delay)

    # 温度の読み出しコマンドを送る
    I2C.write(ref, @i2c_addr, <<0b00000101>>)
    # 処理完了まで一定時間待機
    Process.sleep(@i2c_delay)

    # 温度を読み出す
    ret =
      case I2C.read(ref, @i2c_addr, 2) do
        # 正常に値が取得できたときは温度・湿度の値をタプルで返す
        {:ok, val} -> {:ok, val |> convert()}
        # センサからの応答がないときはメッセージを返す
        {:error, :i2c_nak} -> {:error, "Sensor is not connected"}
        # その他のエラーのときもメッセージを返す
        _ -> {:error, "Unexpected error occurred"}
      end

    # I2Cを閉じる
    I2C.close(ref)

    # 結果を返す
    ret
  end

  # 生データを温度と湿度の値に変換
  ## Parameters
  ## - val: POSTする内容
  defp convert(src) do
    # バイナリデータ部をビット長でパターンマッチ
    # << Ta≧Tcrit::1, Ta＞Tupper::1, Ta＜Tlower::1, 2の補数表現13bit >>
    <<_alart::3, raw_temp::signed-integer-size(13)>> = src

    # 温度に換算する計算（データシートの換算方法に準じた）
    temp = raw_temp / 16.0

    # 温度と湿度をタプルにして返す（MCP9808は湿度がないので2つ目は nil を返す）
    {temp, nil}
  end
end
