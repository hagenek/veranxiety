defmodule Veranxiety.AllergyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Veranxiety.Allergy` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-09-21],
        notes: "some notes",
        symptoms: "some symptoms"
      })
      |> Veranxiety.Allergy.create_entry()

    entry
  end
end
