# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phlog,
  ecto_repos: [Phlog.Repo]

# Configures the endpoint
config :phlog, PhlogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4l1Rnro+6qT2mADa5+ZPJKI1ZkSLgRCGCJfXmThHjceP0haNet1Q2EBvhyU1MXEn",
  render_errors: [view: PhlogWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phlog.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "dev"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
