defmodule Veranxiety.TrainingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Veranxiety.Training` context.
  """

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        duration: 42,
        notes: "some notes",
        success: true
      })
      |> Veranxiety.Training.create_session()

    session
  end
end
