defmodule Veranxiety.Repo.Migrations.UpdateAllergyEntries do
  use Ecto.Migration

  def change do
    alter table(:allergy_entries) do
      add :itch_score, :integer
    end
  end
end
