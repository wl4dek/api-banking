defmodule ApiBankingWeb.UserController do
  use ApiBankingWeb, :controller

  alias ApiBanking.{Accounts, Guardian}
  alias ApiBanking.Accounts.User

  action_fallback ApiBankingWeb.FallbackController

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

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
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
