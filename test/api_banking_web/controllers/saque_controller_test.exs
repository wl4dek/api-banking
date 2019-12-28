defmodule ApiBankingWeb.SaqueControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Saques
  alias ApiBanking.Saques.Saque

  @create_attrs %{
    value: 120.5
  }
  @update_attrs %{
    value: 456.7
  }
  @invalid_attrs %{value: nil}

  def fixture(:saque) do
    {:ok, saque} = Saques.create_saque(@create_attrs)
    saque
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all saques", %{conn: conn} do
      conn = get(conn, Routes.saque_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create saque" do
    test "renders saque when data is valid", %{conn: conn} do
      conn = post(conn, Routes.saque_path(conn, :create), saque: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.saque_path(conn, :show, id))

      assert %{
               "id" => id,
               "value" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.saque_path(conn, :create), saque: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update saque" do
    setup [:create_saque]

    test "renders saque when data is valid", %{conn: conn, saque: %Saque{id: id} = saque} do
      conn = put(conn, Routes.saque_path(conn, :update, saque), saque: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.saque_path(conn, :show, id))

      assert %{
               "id" => id,
               "value" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, saque: saque} do
      conn = put(conn, Routes.saque_path(conn, :update, saque), saque: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete saque" do
    setup [:create_saque]

    test "deletes chosen saque", %{conn: conn, saque: saque} do
      conn = delete(conn, Routes.saque_path(conn, :delete, saque))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.saque_path(conn, :show, saque))
      end
    end
  end

  defp create_saque(_) do
    saque = fixture(:saque)
    {:ok, saque: saque}
  end
end
