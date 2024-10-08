# File: lib/veranxiety/allergy/entry.ex

defmodule Veranxiety.Allergy.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "allergy_entries" do
    field :date, :date
    field :itch_score, :integer
    field :symptoms, :string
    field :notes, :string
    field :current_food, :string

    belongs_to :user, Veranxiety.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:date, :itch_score, :symptoms, :notes, :current_food, :user_id])
    |> validate_required([:date, :itch_score, :user_id])
    |> validate_number(:itch_score, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
  end
end
