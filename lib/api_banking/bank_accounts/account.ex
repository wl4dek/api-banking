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
    |> cast(attrs, [:agency, :account, :balance, :user_id])
    |> validate_required([:agency, :account, :balance, :user_id])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> receber_mil
  end

  def receber_mil(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{balance: money, user_id: _}}
        ->
          put_change(changeset, :balance, money + 1000)
      _ ->
          changeset
    end
  end
end
