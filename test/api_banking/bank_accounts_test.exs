defmodule ApiBanking.BankAccountsTest do
  use ApiBanking.DataCase

  alias ApiBanking.BankAccounts

  describe "accounts" do
    alias ApiBanking.BankAccounts.Account

    @valid_attrs %{account: 42, agency: 42, balance: 120.5}
    @update_attrs %{account: 43, agency: 43, balance: 456.7}
    @invalid_attrs %{account: nil, agency: nil, balance: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> BankAccounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert BankAccounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert BankAccounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = BankAccounts.create_account(@valid_attrs)
      assert account.account == 42
      assert account.agency == 42
      assert account.balance == 120.5
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BankAccounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = BankAccounts.update_account(account, @update_attrs)
      assert account.account == 43
      assert account.agency == 43
      assert account.balance == 456.7
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = BankAccounts.update_account(account, @invalid_attrs)
      assert account == BankAccounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = BankAccounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> BankAccounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = BankAccounts.change_account(account)
    end
  end
end
