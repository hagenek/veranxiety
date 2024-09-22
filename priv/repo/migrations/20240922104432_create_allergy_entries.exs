defmodule Veranxiety.Repo.Migrations.CreateAllergyEntries do
  use Ecto.Migration

  def change do
    create table(:allergy_entries) do
      add :date, :date
      add :symptoms, :text
      add :notes, :text

      timestamps(type: :utc_datetime)
    end
  end
end
