defmodule ApiBankingWeb.TransferController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

  alias ApiBanking.{BankTransfer, BankAccounts}
  alias ApiBanking.BankTransfer.Transfer

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    transfers = BankTransfer.list_transfers()
    render(conn, "index.json", transfers: transfers)
  end

  swagger_path :create do
    post "/api/v1/transfer"
    parameter :value, :path, :string, "valor da tranferência", required: true
    parameter :origin, :path, :string, "UUID da conta de origem do dinheiro", required: true
    parameter :destination, :path, :string, "UUID da conta de destino do dinheiro", required: true
    summary "Fazendo transferencia"
    description "Fazendo uma tranferencia de uma conta para outra"
    produces "application/json"
    tag "Transfers"
    response 200, "OK", Schema.ref(:Transfer)
    response 401, "Unauthorized"
  end

  def create(conn, %{"transfer" => transfer_params}) do
    with {:ok, %Transfer{} = transfer} <- BankTransfer.create_transfer(transfer_params) do
      transfer(transfer.origin, transfer.destination, transfer.value)
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.transfer_path(conn, :show, transfer))
      |> render("show.json", transfer: transfer)
    end
  end

  def transfer(id_origem, id_destino, value_transfer) do
    origem = BankAccounts.get_account!(id_origem)
    destino = BankAccounts.get_account!(id_destino)

    BankAccounts.update_account(origem, %{balance: origem.balance - value_transfer})
    BankAccounts.update_account(destino, %{balance: destino.balance + value_transfer})
  end

  swagger_path :show do
    get "/api/v1/transfer/{id}"
    parameter :id, :path, :string, "UUID da transferência", required: true
    summary "Show transferenci"
    description "Mostra as informações da tranferência"
    produces "application/json"
    tag "Transfers"
    response 200, "OK", Schema.ref(:Transfer)
    response 401, "Unauthorized"
  end

  def show(conn, %{"id" => id_account}) do
    transfers = BankTransfer.get_transfer_by_id_account(id_account)
    render(conn, "index.json", transfers: transfers)
  end
end
