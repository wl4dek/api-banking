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
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> validate_number(:value, greater_than_or_equal_to: 0)
    |> validate_transfer
  end


  defp validate_transfer(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{value: val}}
        ->
          case ApiBanking.BankAccounts.get_account!(:origin) do
            account ->
              case account.balance < val do
                true -> add_error(changeset, :value, "is not a value valid")
              end
          end
      _ ->
          changeset
    end
  end

end
