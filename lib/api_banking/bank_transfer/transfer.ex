defmodule ApiBanking.BankTransfer.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transfers" do
    field :value, :float
    field :origin, :binary_id
    field :destination, :binary_id

    timestamps()
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
    |> cast(attrs, [:value, :origin, :destination])
    |> validate_required([:value, :origin, :destination])
    |> validate_number(:value, greater_than_or_equal_to: 0)
    |> validate_transfer
  end


  defp validate_transfer(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{value: val, origin: orig}}
        ->
          case ApiBanking.BankAccounts.get_account!(orig) do
            account ->
              case account.balance < val do
                true -> add_error(changeset, :value, "insufficient funds")
                false -> changeset
              end
          end
      _ ->
          changeset
    end
  end

end
