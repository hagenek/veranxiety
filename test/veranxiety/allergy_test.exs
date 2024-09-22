defmodule Veranxiety.AllergyTest do
  use Veranxiety.DataCase

  alias Veranxiety.Allergy

  describe "allergy_entries" do
    alias Veranxiety.Allergy.Entry

    import Veranxiety.AllergyFixtures

    @invalid_attrs %{date: nil, symptoms: nil, notes: nil}

    test "list_allergy_entries/0 returns all allergy_entries" do
      entry = entry_fixture()
      assert Allergy.list_allergy_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Allergy.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{date: ~D[2024-09-21], symptoms: "some symptoms", notes: "some notes"}

      assert {:ok, %Entry{} = entry} = Allergy.create_entry(valid_attrs)
      assert entry.date == ~D[2024-09-21]
      assert entry.symptoms == "some symptoms"
      assert entry.notes == "some notes"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Allergy.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      update_attrs = %{date: ~D[2024-09-22], symptoms: "some updated symptoms", notes: "some updated notes"}

      assert {:ok, %Entry{} = entry} = Allergy.update_entry(entry, update_attrs)
      assert entry.date == ~D[2024-09-22]
      assert entry.symptoms == "some updated symptoms"
      assert entry.notes == "some updated notes"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Allergy.update_entry(entry, @invalid_attrs)
      assert entry == Allergy.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Allergy.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Allergy.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Allergy.change_entry(entry)
    end
  end
end
