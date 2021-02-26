defmodule Sensor.ButtonServer do
  use GenServer
  require Logger

  alias Sensor.ConstNerves
  @led ConstNerves.gpio_led
  @button ConstNerves.gpio_button
  @led_off ConstNerves.led_off

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    {:ok, button} = Circuits.GPIO.open(@button, :input, pull_mode: :pullup)
    {:ok, led} = Circuits.GPIO.open(@led, :output)

    # Circuits.GPIO.set_interrupts(button, :both)
    Circuits.GPIO.set_interrupts(button, :rising)

    {:ok, %{button: button, led: led}}
  end

  def handle_info({:circuits_gpio, @button, _timestamp, value}, state) do
    Logger.info("Button => #{value}")

    Circuits.GPIO.write(state.led, value)

    Sensor.Aht20.read_from_aht20() |> Sensor.WebPost.senddata()
    Process.sleep(100)
    Circuits.GPIO.write(state.led, @led_off)

    {:noreply, state}
  end
end
