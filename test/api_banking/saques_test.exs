defmodule ApiBanking.SaquesTest do
  use ApiBanking.DataCase

  alias ApiBanking.Saques

  describe "saques" do
    alias ApiBanking.Saques.Saque

    @valid_attrs %{value: 120.5}
    @update_attrs %{value: 456.7}
    @invalid_attrs %{value: nil}

    def saque_fixture(attrs \\ %{}) do
      {:ok, saque} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Saques.create_saque()

      saque
    end

    test "list_saques/0 returns all saques" do
      saque = saque_fixture()
      assert Saques.list_saques() == [saque]
    end

    test "get_saque!/1 returns the saque with given id" do
      saque = saque_fixture()
      assert Saques.get_saque!(saque.id) == saque
    end

    test "create_saque/1 with valid data creates a saque" do
      assert {:ok, %Saque{} = saque} = Saques.create_saque(@valid_attrs)
      assert saque.value == 120.5
    end

    test "create_saque/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Saques.create_saque(@invalid_attrs)
    end

    test "update_saque/2 with valid data updates the saque" do
      saque = saque_fixture()
      assert {:ok, %Saque{} = saque} = Saques.update_saque(saque, @update_attrs)
      assert saque.value == 456.7
    end

    test "update_saque/2 with invalid data returns error changeset" do
      saque = saque_fixture()
      assert {:error, %Ecto.Changeset{}} = Saques.update_saque(saque, @invalid_attrs)
      assert saque == Saques.get_saque!(saque.id)
    end

    test "delete_saque/1 deletes the saque" do
      saque = saque_fixture()
      assert {:ok, %Saque{}} = Saques.delete_saque(saque)
      assert_raise Ecto.NoResultsError, fn -> Saques.get_saque!(saque.id) end
    end

    test "change_saque/1 returns a saque changeset" do
      saque = saque_fixture()
      assert %Ecto.Changeset{} = Saques.change_saque(saque)
    end
  end
end
