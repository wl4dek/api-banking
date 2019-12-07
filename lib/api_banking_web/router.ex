defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiBankingWeb do
    pipe_through :api

    # post "/login", UserController, :login
    # resources "/user", UserController, only: [:index, :create, :show, :delete]
    # resources "/account", AccountController, only: [:index]
  end
end
