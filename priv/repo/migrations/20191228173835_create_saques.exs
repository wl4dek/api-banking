defmodule ApiBanking.Repo.Migrations.CreateSaques do
  use Ecto.Migration

  def change do
    create table(:saques, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :float
      add :origin, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:saques, [:origin])
  end
end
