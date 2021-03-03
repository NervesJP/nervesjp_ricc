defmodule Sensor.ConstNerves do
  @moduledoc """
  定数を定義するためのモジュール
  """

  def my_name(), do: "ricc_piot_kikuyuta"
  def url_temp(), do: "http://" <> System.get_env("NERVES_IP") <> "/api/temp"
  def url_humi(), do: "http://" <> System.get_env("NERVES_IP") <> "/api/humi"

  def gpio_button(), do: 5
  def gpio_led(), do: 16
  def led_off(), do: 0

  def i2c_bus(), do: i2c_bus_bbb()
  def i2c_addr(), do: i2c_addr_ina226()
  def i2c_delay_ms(), do: 100
  def i2c_2pow20(), do: 1048576   # 2^20

  def i2c_bus_rpi(), do: "i2c-1"
  def i2c_bus_bbb(), do: "i2c-2"
  def i2c_addr_mcp9808(), do: 0x18
  def i2c_addr_aht20(), do: 0x38
  def i2c_addr_ina226(), do: 0x41
end
