defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.BankAccounts
  alias ApiBanking.BankAccounts.Account

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    accounts = BankAccounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- BankAccounts.create_account(account_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  def show(conn, %{"id" => id}) do
    account = BankAccounts.get_account!(id)
    render(conn, "show.json", account: account)
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
