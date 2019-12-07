defmodule ApiBanking.BankTransferTest do
  use ApiBanking.DataCase

  alias ApiBanking.BankTransfer

  describe "transfers" do
    alias ApiBanking.BankTransfer.Transfer

    @valid_attrs %{value: 120.5}
    @update_attrs %{value: 456.7}
    @invalid_attrs %{value: nil}

    def transfer_fixture(attrs \\ %{}) do
      {:ok, transfer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> BankTransfer.create_transfer()

      transfer
    end

    test "list_transfers/0 returns all transfers" do
      transfer = transfer_fixture()
      assert BankTransfer.list_transfers() == [transfer]
    end

    test "get_transfer!/1 returns the transfer with given id" do
      transfer = transfer_fixture()
      assert BankTransfer.get_transfer!(transfer.id) == transfer
    end

    test "create_transfer/1 with valid data creates a transfer" do
      assert {:ok, %Transfer{} = transfer} = BankTransfer.create_transfer(@valid_attrs)
      assert transfer.value == 120.5
    end

    test "create_transfer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BankTransfer.create_transfer(@invalid_attrs)
    end

    test "update_transfer/2 with valid data updates the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{} = transfer} = BankTransfer.update_transfer(transfer, @update_attrs)
      assert transfer.value == 456.7
    end

    test "update_transfer/2 with invalid data returns error changeset" do
      transfer = transfer_fixture()
      assert {:error, %Ecto.Changeset{}} = BankTransfer.update_transfer(transfer, @invalid_attrs)
      assert transfer == BankTransfer.get_transfer!(transfer.id)
    end

    test "delete_transfer/1 deletes the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{}} = BankTransfer.delete_transfer(transfer)
      assert_raise Ecto.NoResultsError, fn -> BankTransfer.get_transfer!(transfer.id) end
    end

    test "change_transfer/1 returns a transfer changeset" do
      transfer = transfer_fixture()
      assert %Ecto.Changeset{} = BankTransfer.change_transfer(transfer)
    end
  end
end
