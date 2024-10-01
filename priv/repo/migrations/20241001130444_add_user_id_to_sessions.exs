defmodule Veranxiety.Repo.Migrations.AddUserIdToSessions do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:sessions, [:user_id])
  end
end
