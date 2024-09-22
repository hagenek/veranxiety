defmodule Veranxiety.Allergy.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "allergy_entries" do
    field :date, :date
    field :itch_score, :integer
    field :symptoms, :string
    field :notes, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:date, :itch_score, :symptoms, :notes])
    |> validate_required([:date, :itch_score])
    |> validate_number(:itch_score, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
  end
end
