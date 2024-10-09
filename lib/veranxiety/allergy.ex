defmodule Veranxiety.Allergy do
  @moduledoc """
  The Allergy context.
  """

  import Ecto.Query, warn: false
  alias Veranxiety.Repo
  alias Veranxiety.Allergy.Entry
  # Assuming User module exists
  alias Veranxiety.Accounts.User

  @doc """
  Returns the list of allergy entries for a specific user.

  ## Examples

      iex> list_allergy_entries(user)
      [%Entry{}, ...]

  """
  def list_allergy_entries(%User{} = user) do
    Entry
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single entry for a specific user.

  Raises `Ecto.NoResultsError` if the Entry does not exist or does not belong to the user.

  ## Examples

      iex> get_entry!(user, 123)
      %Entry{}

      iex> get_entry!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(%User{} = user, id) do
    Entry
    |> where([e], e.id == ^id and e.user_id == ^user.id)
    |> Repo.one!()
  end

  @doc """
  Gets the most recent entry for a specific user.

  ## Examples

      iex> get_most_recent_entry(user)
      %Entry{}

      iex> get_most_recent_entry(user)
      nil

  """
  def get_most_recent_entry(%User{} = user) do
    Entry
    |> where(user_id: ^user.id)
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Creates a new entry for a specific user.

  ## Examples

      iex> create_entry(user, %{field: value})
      {:ok, %Entry{}}

      iex> create_entry(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(%User{} = user, attrs \\ %{}) do
    %Entry{user_id: user.id}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an entry for a specific user.

  ## Examples

      iex> update_entry(user, entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(user, entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%User{} = _user, %Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an entry for a specific user.

  ## Examples

      iex> delete_entry(user, entry)
      {:ok, %Entry{}}

      iex> delete_entry(user, entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%User{} = user, %Entry{} = entry) do
    if entry.user_id == user.id do
      Repo.delete(entry)
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{data: %Entry{}}

  """
  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end
end
