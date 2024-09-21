defmodule VeranxietyWeb.SessionLive.Index do
  use VeranxietyWeb, :live_view

  alias Veranxiety.Training
  alias Veranxiety.Training.Session

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:sessions, list_sessions())
     |> assign(:changeset, Training.change_session(%Session{}))}
  end

  def get_duration_minutes(changeset) do
    case Ecto.Changeset.get_field(changeset, :duration) do
      nil -> ""
      duration -> div(duration, 60)
    end
  end

  def get_duration_seconds(changeset) do
    case Ecto.Changeset.get_field(changeset, :duration) do
      nil -> ""
      duration -> rem(duration, 60)
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("validate", %{"session" => session_params}, socket) do
    changeset =
      %Session{}
      |> Training.change_session(session_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    session = Training.get_session!(id)
    {:ok, _} = Training.delete_session(session)

    {:noreply, assign(socket, :sessions, list_sessions())}
  end

  @impl true
  def handle_event("save", %{"session" => session_params}, socket) do
    case create_or_update_session(socket, session_params) do
      {:ok, _session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Session saved successfully")
         |> push_navigate(to: ~p"/sessions")
         |> assign(:sessions, list_sessions())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    session = Training.get_session!(id)

    socket
    |> assign(:page_title, "Edit Session")
    |> assign(:session, session)
    |> assign(:changeset, Training.change_session(session))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Session")
    |> assign(:session, %Session{})
    |> assign(:changeset, Training.change_session(%Session{}))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sessions")
    |> assign(:session, nil)
    |> assign(:changeset, Training.change_session(%Session{}))
  end

  defp list_sessions do
    Training.list_sessions()
  end

  defp create_or_update_session(socket, session_params) do
    session_params = convert_duration(session_params)

    case socket.assigns.live_action do
      :edit ->
        Training.update_session(socket.assigns.session, session_params)

      :new ->
        Training.create_session(session_params)
    end
  end

  defp convert_duration(params) do
    minutes = parse_integer(params["duration_minutes"])
    seconds = parse_integer(params["duration_seconds"])
    total_seconds = minutes * 60 + seconds
    Map.put(params, "duration", total_seconds)
  end

  defp parse_integer(value) when is_binary(value) do
    case Integer.parse(value) do
      {int, _} -> int
      :error -> 0
    end
  end

  defp parse_integer(_), do: 0

  def format_duration(duration) when is_integer(duration) do
    minutes = div(duration, 60)
    seconds = rem(duration, 60)
    "#{minutes} min #{seconds} sec"
  end
end
