defmodule ApiBankingWeb.TransferControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.BankTransfer

  @create_attrs %{
    value: 120.5
  }
  @invalid_attrs %{value: nil}

  def fixture(:transfer) do
    {:ok, transfer} = BankTransfer.create_transfer(@create_attrs)
    transfer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transfers", %{conn: conn} do
      conn = get(conn, Routes.transfer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transfer" do
    test "renders transfer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transfer_path(conn, :show, id))

      assert %{
               "id" => id,
               "value" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
