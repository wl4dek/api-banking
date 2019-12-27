defmodule ApiBankingWeb.TransferController do
  use ApiBankingWeb, :controller

  alias ApiBanking.{BankTransfer, BankAccounts}
  alias ApiBanking.BankTransfer.Transfer

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    transfers = BankTransfer.list_transfers()
    render(conn, "index.json", transfers: transfers)
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

  def show(conn, %{"id" => id_account}) do
    transfers = BankTransfer.get_transfer_by_id_account(id_account)
    render(conn, "index.json", transfers: transfers)
  end
end
