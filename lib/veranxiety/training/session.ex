defmodule Veranxiety.Training.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :duration, :integer
    field :success, :boolean, default: false
    field :notes, :string

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:duration, :success, :notes])
    |> validate_required([:duration, :success])
  end
end
