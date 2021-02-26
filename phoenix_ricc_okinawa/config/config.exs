# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :phoenix_ricc_okinawa, PhoenixRiccOkinawaWeb.Endpoint,
  url: [host: "localhost"],
  # secret_key_base: "POHOxB9xPPjMZhCRmm5ZQWpdA68C+W+kolbE1IrXy+pmJN0RjrfTp8CzIbuK966R",
  secret_key_base: "l2UceS1OzsN63BO9DLAScGstHPZGPrxsVG8I2Fx79s3Gp7KU4HJmmxrNzD0RDiO8",
  render_errors: [view: PhoenixRiccOkinawaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhoenixRiccOkinawa.PubSub,
  live_view: [signing_salt: "d/oLTf/R"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
