defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

  alias ApiBanking.BankAccounts
  alias ApiBanking.BankAccounts.Account

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    accounts = BankAccounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  swagger_path :create do
    post "/api/v1/account"
    parameter :account, :path, :string, "Número da Conta do usuário", required: true
    parameter :agency, :path, :string, "Número da Agencia do usuário", required: true
    parameter :balance, :path, :string, "Saldo da conta do usuário", required: true
    parameter :user_id, :path, :string, "Id do usuário", required: true
    summary "Criando Conta"
    description "Criando a conta do banco do usuário"
    produces "application/json"
    tag "Accounts"
    response 200, "OK", Schema.ref(:Accounts)
    response 401, "Unauthorized"
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- BankAccounts.create_account(account_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  swagger_path :show do
    get "/api/v1/account/{id}"
    parameter :id, :path, :string, "UUID da Conta do usuário", required: true
    summary "Show Conta"
    description "Recuperando a conta do banco de um usuário"
    produces "application/json"
    tag "Accounts"
    response 200, "OK", Schema.ref(:Accounts)
    response 401, "Unauthorized"
  end

  def show(conn, %{"id" => id}) do
    account = BankAccounts.get_account!(id)
    render(conn, "show.json", account: account)
  end

  swagger_path :update do
    put "/api/v1/account"
    parameter :id, :path, :string, "UUID da Conta do usuário", required: true
    parameter :account, :path, :string, "Número da Conta do usuário", required: true
    parameter :agency, :path, :string, "Número da Agencia do usuário", required: true
    parameter :balance, :path, :string, "Saldo da conta do usuário", required: true
    parameter :user_id, :path, :string, "Id do usuário", required: true
    summary "Update Conta"
    description "Update da conta do banco de um usuário"
    produces "application/json"
    tag "Accounts"
    response 200, "OK", Schema.ref(:Accounts)
    response 401, "Unauthorized"
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = BankAccounts.get_account!(id)

    with {:ok, %Account{} = account} <- BankAccounts.update_account(account, account_params) do
      render(conn, "show.json", account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = BankAccounts.get_account!(id)

    with {:ok, %Account{}} <- BankAccounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
