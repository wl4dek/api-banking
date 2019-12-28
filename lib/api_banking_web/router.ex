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
    end
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Api Banking"
      },
      definitions: %{
        "Users" => %{
          email: "string",
          name: "string",
          password: "string"
        },
        "UserList" => %{
          data: [
            %{
              email: "string",
              name: "string",
              password: "string"
            }
          ]
        },
        "Accounts" => %{
          account: "number",
          agency: "number",
          balance: "float",
          user_id: "uuid"
        },
        "Transfer" => %{
          value: "float",
          origin: "uuid",
          destination: "uuid"
        }
      }
    }
  end

  scope "/" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :api_banking, swagger_file: "swagger.json"
  end
end
