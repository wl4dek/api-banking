defmodule ApiBankingWeb.TransferController do
  use ApiBankingWeb, :controller

  alias ApiBanking.BankTransfer
  alias ApiBanking.BankTransfer.Transfer

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    transfers = BankTransfer.list_transfers()
    render(conn, "index.json", transfers: transfers)
  end

  def create(conn, %{"transfer" => transfer_params}) do
    with {:ok, %Transfer{} = transfer} <- BankTransfer.create_transfer(transfer_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.transfer_path(conn, :show, transfer))
      |> render("show.json", transfer: transfer)
    end
  end

  def show(conn, %{"id" => id}) do
    transfer = BankTransfer.get_transfer!(id)
    render(conn, "show.json", transfer: transfer)
  end

  # def update(conn, %{"id" => id, "transfer" => transfer_params}) do
  #   transfer = BankTransfer.get_transfer!(id)

  #   with {:ok, %Transfer{} = transfer} <- BankTransfer.update_transfer(transfer, transfer_params) do
  #     render(conn, "show.json", transfer: transfer)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   transfer = BankTransfer.get_transfer!(id)

  #   with {:ok, %Transfer{}} <- BankTransfer.delete_transfer(transfer) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
