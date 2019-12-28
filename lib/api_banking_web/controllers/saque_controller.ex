defmodule ApiBankingWeb.SaqueController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

  alias ApiBanking.{Saques, BankAccounts}
  alias ApiBanking.Saques.Saque

  action_fallback ApiBankingWeb.FallbackController

  swagger_path :create do
    post "/api/v1/withdraw"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    summary "Usuário saca dinheiro"
    description "Usuário saca dinheiro"
    produces "application/json"
    tag "Saques"
    response 200, "OK", Schema.ref(:Saques)
    response 401, "Unauthorized"
  end

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

  swagger_path :show do
    get "/api/v1/withdraw/{id}"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    summary "Get saque da conta"
    description "recupera o saque da conta do usuário pelo UUID"
    produces "application/json"
    tag "Saques"
    response 200, "OK", Schema.ref(:Saques)
    response 401, "Unauthorized"
  end

  def show(conn, %{"id" => id}) do
    saque = Saques.get_saque!(id)
    render(conn, "show.json", saque: saque)
  end
end
