defmodule ApiBankingWeb.SaqueController do
  use ApiBankingWeb, :controller

  alias ApiBanking.{Saques, BankAccounts}
  alias ApiBanking.Saques.Saque

  action_fallback ApiBankingWeb.FallbackController

  def create(conn, %{"saque" => saque_params}) do
    with {:ok, %Saque{} = saque} <- Saques.create_saque(saque_params) do
      sacar_dinheiro(saque.origin, saque.value)
      conn
      |> put_status(:created)
      |> render("show.json", saque: saque)
    end
  end

  def sacar_dinheiro(id_origem, value_saque) do
    origem = BankAccounts.get_account!(id_origem)
    BankAccounts.update_account(origem, %{balance: origem.balance - value_saque})
  end

  def show(conn, %{"account_id" => id}) do
    saque = Saques.get_saque!(id)
    render(conn, "show.json", saque: saque)
  end
end
