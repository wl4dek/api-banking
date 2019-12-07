defmodule ApiBanking.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :float
      add :origin, references(:account, on_delete: :nothing, type: :binary_id)
      add :destination, references(:account, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:transfers, [:origin])
    create index(:transfers, [:destination])
  end
end
