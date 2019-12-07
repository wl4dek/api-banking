defmodule ApiBanking.Repo.Migrations.CreateAgency do
  use Ecto.Migration

  def change do
    create table(:agency, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :account, :string
      add :balance, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:agency, [:user_id])
  end
end
