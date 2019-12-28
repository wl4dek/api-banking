defmodule ApiBanking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :password, :string

      timestamps()
    end

    create unique_index(:users, [:email, :id], name: :users_email_company_id_index)

  end
end
