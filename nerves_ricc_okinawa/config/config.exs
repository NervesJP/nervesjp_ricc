# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :nerves_ricc_okinawa, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1613789624"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]


#==============================
# add
#==============================
import_config("../../phoenix_ricc_okinawa/config/config.exs")
import_config("../../phoenix_ricc_okinawa/config/prod.exs")


config :phoenix_ricc_okinawa, PhoenixRiccOkinawaWeb.Endpoint,
  code_reloader: false,           # Nerves root filesystem is read-only, so disable the code reloader
  http: [port: 80],
  load_from_system_env: false,    # Use compile-time Mix config instead of runtime environment variables
  server: true,                   # Start the server since we're running in a release instead of through `mix`
  url: [host: "localhost", port: 80]


config :tzdata, :data_dir, "/data/tzdata"


if Mix.target() == :host or Mix.target() == :"" do
  import_config "host.exs"
else
  import_config "target.exs"
end
