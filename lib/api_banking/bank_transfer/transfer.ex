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
  end
end
