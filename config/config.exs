# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :spot_me,
  ecto_repos: [SpotMe.Repo]

# Configures the endpoint
config :spot_me, SpotMeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3UsCwgl2aCTp0YEaagPr0QMdwTTBpm1k8euAW1Yc0osNpb820k5iMBkOx1HKiSAs",
  render_errors: [view: SpotMeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SpotMe.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
