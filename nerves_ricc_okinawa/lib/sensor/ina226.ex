defmodule Sensor.Ina226 do
  @moduledoc """
  Documentation for `Ina226`.
  電流電圧センサ TI INA226 の制御モジュール
  """

  # 関連するライブラリを読み込み
  require Logger
  alias Circuits.I2C

  # 定数
  alias Sensor.ConstNerves
  @i2c_bus ConstNerves.i2c_bus
  @i2c_addr ConstNerves.i2c_addr
  @i2c_delay ConstNerves.i2c_delay_ms

  @doc """
  電流を表示
  ## Examples
    iex> Sensor.Ina226.print_current
    > curr: 22.1 (mA)
    :ok
  """
  def print_curr() do
    IO.puts(" > current: #{read_ina226(:curr)} (mA)")
  end


  @doc """
  電圧を表示
  ## Examples
    iex> Sensor.Ina226.print_volt
    > volt 41.2 (V)
    :ok
  """
  def print_volt() do
    IO.puts(" > voltage: #{read_ina226(:volt)} (V)")
  end

  @doc """
  電力を表示
  ## Examples
    iex> Sensor.Ina226.print_watt
    > watt: 1890.025 (mW)
    :ok
  """
  def print_watt() do
    case read_ina226() do
      {:ok, {_, _, watt}} -> IO.puts(" > power: #{watt} (mW)")
      error -> IO.puts("#{inspect(error)}")
    end
  end


  @doc """
  INA226 から電流・電圧・電力を取得
  ## Examples
    iex> Sensor.Ina226.read_ina226()
    {:ok, {22.4, 5.000, 112.0}}
    {:error, "Sensor is not connected"}
  """

  def read_ina226() do
    curr = read_ina226(:curr)
    volt = read_ina226(:volt)
    case {curr, volt} do
      {curr, volt} when is_number(curr) and is_number(volt)
        -> {:ok, {curr, volt, Float.round(curr*volt,1)}}
      _ -> {:error, {curr, volt}}
    end
  end
  
  @doc """
  INA226 から電流ないしは電圧を取得
  ## Examples
    iex> Sensor.Ina226.read_ina226(:curr)
    22.4
    {:error, "Sensor is not connected"}
    iex> Sensor.Ina227.read_ina226(:volt)
    5.000
    {:error, "Unexpected error occurred"}
  """

  def read_ina226(type) do
    # I2Cを開く
    {:ok, ref} = I2C.open(@i2c_bus)

    # INA226 を初期化する
    # I2C.write(ref, @i2c_addr, <<0x00>>)
    # 処理完了まで一定時間待機
    # Process.sleep(@i2c_delay)

    # 電流読み出しコマンドを送る
    I2C.write(ref, @i2c_addr, case type do :curr -> <<1>>; :volt -> <<2>> end)
    # I2C.write(ref, @i2c_addr, <<0x1>>)
    # 処理完了まで一定時間待機
    Process.sleep(@i2c_delay)

    # 電流を読み出す
    raw =
      case I2C.read(ref, @i2c_addr, 2) do
        {:ok, val} -> val
        {:error, :i2c_nak} -> {:error, "Sensor is not connected"}
        _ -> {:error, "Unexpected error occurred"}
      end

    ret =
      case {type, raw} do
        {:curr, <<int::signed-integer-size(16)>>}   -> Float.round(int/10, 1)
        {:volt, <<int::unsigned-integer-size(16)>>} -> Float.round(int/800, 5)
        _ -> raw
    end

    # I2Cを閉じる
    I2C.close(ref)

    # 結果を返す
    ret
  end
end
