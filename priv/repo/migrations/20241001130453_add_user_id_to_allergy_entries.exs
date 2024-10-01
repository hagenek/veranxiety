defmodule Veranxiety.Repo.Migrations.AddUserIdToAllergyEntries do
  use Ecto.Migration

  def change do
    alter table(:allergy_entries) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:allergy_entries, [:user_id])
  end
end
