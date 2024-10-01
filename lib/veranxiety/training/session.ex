# File: ./veranxiety/training/session.ex

defmodule Veranxiety.Training.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :duration, :integer
    field :success, :boolean, default: false
    field :notes, :string

    belongs_to :user, Veranxiety.Accounts.User  # Add this line

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:duration, :success, :notes, :user_id])  # Include :user_id
    |> validate_required([:duration, :success, :user_id])    # Validate :user_id
    |> validate_number(:duration, greater_than_or_equal_to: 0)
  end
end
