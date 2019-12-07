defmodule ApiBanking.BankAccounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :account, :integer
    field :agency, :integer
    field :balance, :float
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:agency, :account, :balance])
    |> validate_required([:agency, :account, :balance])
  end
end
