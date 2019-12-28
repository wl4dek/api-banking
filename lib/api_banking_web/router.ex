defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.Pipeline,  module: ApiBanking.Guardian, error_handler: ApiBanking.Guardian.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", ApiBankingWeb do
    pipe_through :api

    scope "/v1", as: :api_v1 do
      post "/login", UserController, :login
      resources "/user", UserController, only: [:create]
    end
  end

  scope "/api", ApiBankingWeb do
    pipe_through [:api, :api_auth]

    scope "/v1", as: :api_v1 do
      post "/logout", UserController, :logout
      resources "/user", UserController, only: [:index, :show, :delete, :update]
      resources "/account", AccountController, only: [:index, :create, :show, :delete, :update]
      resources "/transfer", TransferController, only: [:index, :create, :show]
      resources "/withdraw", SaqueController, only: [:create, :show]
      get "/transacionado/day", TransacionadoController, :transacionado_by_day
      get "/transacionado/month", TransacionadoController, :transacionado_by_month
      get "/transacionado/year", TransacionadoController, :transacionado_by_year
    end
  end
end
