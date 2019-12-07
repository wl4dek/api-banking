defmodule ApiBanking.BankAccounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "agency" do
    field :account, :string
    field :balance, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account, :balance])
    |> validate_required([:account, :balance])
  end
end
