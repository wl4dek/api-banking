defmodule ApiBankingWeb.UserController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

  alias ApiBanking.{Accounts, Guardian}
  alias ApiBanking.Accounts.User

  action_fallback ApiBankingWeb.FallbackController

  swagger_path :index do
    get "/api/v1/user"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    summary "List all recorded of User"
    description "Lista todos os usuário"
    produces "application/json"
    tag "Users"
    response 200, "OK", Schema.ref(:User)
    response 401, "Unauthorized"
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  swagger_path :show do
    get "/api/v1/user/{id}"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    parameter :id, :path, :string, "User UUID", required: true
    summary "List User by Id"
    description "Recupera um usuário pelo seu UUID"
    produces "application/json"
    tag "Users"
    response 200, "OK", Schema.ref(:Users)
    response 401, "Unauthorized"
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  swagger_path :update do
    put "/api/v1/user"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    parameter :id, :path, :string, "User UUID", required: true
    parameter :user, :path, :object, "Informações do usuário que sera atualizada", required: true
    summary "Update User"
    description "Recupera um usuário pelo seu UUID e faz o update dos dados"
    produces "application/json"
    tag "Users"
    response 200, "OK", Schema.ref(:Users)
    response 401, "Unauthorized"
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path :login do
    post "/api/v1/login"
    parameter :email, :path, :string, "Email do usuário", required: true
    parameter :password, :path, :string, "Password do usuário", required: true
    summary "Login User"
    description "Faz a autenticação do usuário"
    produces "application/json"
    tag "Users"
    response 200, "OK", Schema.ref(:Users)
    response 401, "Unauthorized"
  end

  def login(conn, params) do
    case Accounts.find_and_confirm_password(params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.sign_in(conn, user)
        token = Guardian.Plug.current_token(new_conn)
        claims = Guardian.Plug.current_claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
         |> put_resp_header("authorization", "Bearer #{token}")
        #  |> put_resp_header("x-expires", exp)
         |> render("login.json", user: user, token: token, exp: exp)
      {:error, _} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Could not login")
    end
  end

  def logout(conn, _) do
    jwt = Guardian.Plug.current_token(conn)
    # claims = Guardian.Plug.current_claims(conn)
    case Guardian.revoke(jwt) do
      {:ok, _} ->
        conn
        |> render("message.json", message: "Logout")
      {:error, _} ->
        conn
        |> render("message.json", message: "Logout não realizado")
    end
  end

end
