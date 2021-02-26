defmodule ConstNerves do
  @moduledoc """
  定数を定義するためのモジュール
  """

  def my_name(), do: "ricc_okinawa"
  def url_temp(), do: "http://" <> System.get_env("NERVES_IP") <> "/api/temp"
  def url_humi(), do: "http://" <> System.get_env("NERVES_IP") <> "/api/humi"

  def gpio_button(), do: 5
  def gpio_led(), do: 16
  def led_off(), do: 0

  def i2c_bus(), do: "i2c-1"
  def i2c_addr(), do: 0x38
  def i2c_delay_ms(), do: 100
  def i2c_2pow20(), do: 1048576   # 2^20
end
