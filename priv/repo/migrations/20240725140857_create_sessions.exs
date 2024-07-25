defmodule Veranxiety.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :duration, :integer
      add :success, :boolean, default: false, null: false
      add :notes, :text

      timestamps(type: :utc_datetime)
    end
  end
end
