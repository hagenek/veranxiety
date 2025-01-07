defmodule VeranxietyWeb.SessionLive.Index do
  use VeranxietyWeb, :live_view
  alias Veranxiety.Training
  alias Veranxiety.Training.Session

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(:grouped_sessions, list_sessions(current_user))
     |> assign(:changeset, Training.change_session(%Session{}))
     |> assign(:current_user, current_user)}
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
    session = Training.get_session!(socket.assigns.current_user, id)
    {:ok, _} = Training.delete_session(socket.assigns.current_user, session)
    {:noreply, assign(socket, :grouped_sessions, list_sessions(socket.assigns.current_user))}
  end

  @impl true
  def handle_event("save", %{"session" => session_params}, socket) do
    case create_or_update_session(socket, session_params) do
      {:ok, _session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Session saved successfully")
         |> push_navigate(to: ~p"/sessions")
         |> assign(:grouped_sessions, list_sessions(socket.assigns.current_user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("navigate_back", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/sessions")}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    session = Training.get_session!(socket.assigns.current_user, id)

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

  defp list_sessions(user) do
    user
    |> Training.list_sessions()
    |> group_sessions_by_time_window()
  end

  defp group_sessions_by_time_window(sessions) do
    sessions
    |> Enum.sort_by(& &1.inserted_at, :desc)
    |> Enum.group_by(fn session ->
      datetime = session.inserted_at
      # Round down to the nearest even hour to create 2-hour windows
      hour = datetime.hour
      window_start = hour - rem(hour, 2)
      date = NaiveDateTime.to_date(datetime)
      {Date.to_string(date), window_start}
    end)
  end

  defp create_or_update_session(socket, session_params) do
    session_params = convert_duration(session_params)

    case socket.assigns.live_action do
      :edit ->
        Training.update_session(
          socket.assigns.current_user,
          socket.assigns.session,
          session_params
        )

      :new ->
        Training.create_session(socket.assigns.current_user, session_params)
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

  def format_window_time(hour) do
    start_hour = hour
    end_hour = hour + 2
    "#{pad_hour(start_hour)}:00 - #{pad_hour(end_hour)}:00"
  end

  defp pad_hour(hour) do
    hour
    |> rem(24)
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
