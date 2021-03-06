# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api_banking,
  ecto_repos: [ApiBanking.Repo]

# Configures the endpoint
config :api_banking, ApiBankingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "R5kLbyKn+W9Gu7qWEP04VC4sHInqSL3sUmzvYkiEZaU9nye/KvIItXPJNl2QtnbL",
  render_errors: [view: ApiBankingWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApiBanking.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Config Guardian
config :api_banking, ApiBanking.Guardian,
       issuer: "api_banking",
       ttl: { 5, :minutes },
       auth_time: true,
       max_age: { 5, :minutes },
       secret_key: "ZG5wplvwS4QI7tZksodUkKca1TO269OtCsKv/cbgoOYYtdtvP6WqI/FwIAjPfg0t",
       error_handler: ApiBanking.Guardian.AuthErrorHandler

# Config Swagger
config :api_banking, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: ApiBankingWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: ApiBankingWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

config :phoenix_swagger, json_library: Jason
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
