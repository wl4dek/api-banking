defmodule ApiBanking.BankTransferTest do
  use ApiBanking.DataCase

  alias ApiBanking.BankTransfer
  alias ApiBanking.BankAccounts
  alias ApiBanking.Accounts, as: UserAccounts

  describe "transfers" do
    alias ApiBanking.BankTransfer.Transfer

    @valid_user_attrs %{email: "some@email.com", name: "some name", password: "some password"}
    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> UserAccounts.create_user()

      user
    end

    def valid_bank_account_attrs() do
      user = user_fixture()
      %{account: 4242, agency: 4242, balance: 120.5, user_id: user.id}
    end

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(valid_bank_account_attrs())
        |> BankAccounts.create_account()

      account
    end

    def valid_attrs() do
      origem = account_fixture()
      destino = account_fixture()
      %{value: 120.5, origin: origem.id, destination: destino.id}
    end

    @invalid_attrs %{value: nil, origin: nil, destination: nil}

    def transfer_fixture(attrs \\ %{}) do
      {:ok, transfer} =
        attrs
        |> Enum.into(valid_attrs())
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
      assert {:ok, %Transfer{} = transfer} = BankTransfer.create_transfer(valid_attrs())
      assert transfer.value == 120.5
    end

    test "create_transfer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BankTransfer.create_transfer(@invalid_attrs)
    end
  end
end
