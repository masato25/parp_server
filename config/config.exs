# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :parp_server,
  ecto_repos: [ParpServer.Repo],
  login_password: "passwd",
  token_key: "key",
  google_api_key: "gkey"

# Configures the endpoint
config :parp_server, ParpServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hEHrcBSiVKqZhWETYwSMfzSrnf4KRjPUk/JHcx0DybBQjQJfqPhokAjLHdO4JXkk",
  render_errors: [view: ParpServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ParpServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
