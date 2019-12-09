defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug ApiBanking.AuthPipeline
    # plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    # plug Guardian.Plug.LoadResource
  end

  scope "/api", ApiBankingWeb do
    pipe_through :api

    scope "/v1", as: :api_v1 do
      post "/login", UserController, :login
    end
  end

  scope "/api", ApiBankingWeb do
    pipe_through [:api, :api_auth]

    scope "/v1", as: :api_v1 do
      resources "/user", UserController, only: [:index, :create, :show, :delete, :update]
      resources "/account", AccountController, only: [:index, :create, :show, :delete, :update]
      resources "/transfer", TransferController, only: [:index, :create, :show]
    end
  end
end
