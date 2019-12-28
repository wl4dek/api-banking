defmodule ApiBanking.Saques.Saque do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "saques" do
    field :value, :float
    field :origin, :binary_id

    timestamps()
  end

  @doc false
  def changeset(saque, attrs) do
    saque
    |> cast(attrs, [:value, :origin])
    |> validate_required([:value, :origin])
    |> validate_number(:value, greater_than_or_equal_to: 0)
    |> validate_saque
  end

  defp validate_saque(changeset) do
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
