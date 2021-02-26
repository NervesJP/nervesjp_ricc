defmodule ConstPhoenix do
  # def file_path(), do: "/Users/kazuma/git/2021_ricc_okinawa/phoenix_ricc_okinawa"
  def file_path(), do: "/data"
  def temp_file_name(), do: "temp"
  def temp_file(), do: file_path() <> "/" <> temp_file_name()
  def humi_file_name(), do: "humi"
  def humi_file(), do: file_path() <> "/" <> humi_file_name()
end
