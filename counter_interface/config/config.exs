# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :counter_interface, CounterInterfaceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZVD+J/SuR1Bbei8jpzGekT9nT4izrL/IMYZKXgmOrGr4+usKRLisKAhWwIdpAzfa",
  render_errors: [view: CounterInterfaceWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CounterInterface.PubSub,
  live_view: [signing_salt: "rVVcm3iM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
