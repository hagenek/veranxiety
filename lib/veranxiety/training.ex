defmodule Veranxiety.Training do
  import Ecto.Query, warn: false
  alias Veranxiety.Repo
  alias Veranxiety.Training.Session
  alias Veranxiety.Accounts.User

  @doc """
  Returns the list of sessions for a specific user.

  ## Examples

      iex> list_sessions(user)
      [%Session{}, ...]

  """
  def list_sessions(%User{} = user) do
    Session
    |> where([s], s.user_id == ^user.id)
    |> order_by([s], desc: s.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single session for a specific user.

  Raises `Ecto.NoResultsError` if the session does not exist or does not belong to the user.

  ## Examples

      iex> get_session!(user, 123)
      %Session{}

      iex> get_session!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_session!(%User{} = user, id) do
    Session
    |> where([s], s.id == ^id and s.user_id == ^user.id)
    |> Repo.one!()
  end

  @doc """
  Creates a session associated with a user.

  ## Examples

      iex> create_session(user, %{field: value})
      {:ok, %Session{}}

      iex> create_session(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(%User{} = user, attrs \\ %{}) do
    %Session{user_id: user.id}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session for a specific user.

  ## Examples

      iex> update_session(user, session, %{field: new_value})
      {:ok, %Session{}}

      iex> update_session(user, session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session(%User{} = user, %Session{} = session, attrs) do
    if session.user_id == user.id do
      session
      |> Session.changeset(attrs)
      |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a session for a specific user.

  ## Examples

      iex> delete_session(user, session)
      {:ok, %Session{}}

      iex> delete_session(user, session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session(%User{} = user, %Session{} = session) do
    if session.user_id == user.id do
      Repo.delete(session)
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{data: %Session{}}

  """
  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.changeset(session, attrs)
  end
end
