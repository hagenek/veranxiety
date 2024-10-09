defmodule Veranxiety.Repo.Migrations.AddCurrentFoodToAllergyEntries do
  use Ecto.Migration

  def change do
    alter table(:allergy_entries) do
      add :current_food, :string
    end
  end
end
