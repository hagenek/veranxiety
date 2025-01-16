# sessions_live/index.ex
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
     |> assign(:current_user, current_user)
     |> assign(:expanded_session_id, nil)
     |> assign(:page_title, "Training Sessions")}
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

  def handle_event("toggle_session", %{"id" => session_id}, socket) do
    current_expanded = socket.assigns.expanded_session_id
    # Convert the incoming ID to integer
    session_id = String.to_integer(session_id)
    new_expanded = if current_expanded == session_id, do: nil, else: session_id

    {:noreply, assign(socket, :expanded_session_id, new_expanded)}
  end

  def handle_event("refresh_session", %{"id" => _id}, socket) do
    {:noreply, socket}
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

  defp apply_action(socket, :edit, %{"id" => id}) do
    session = Training.get_session!(socket.assigns.current_user, id)

    socket
    |> assign(:page_title, "Edit Session")
    |> assign(:session, session)
    |> assign(:changeset, Training.change_session(session))
    # Close expanded view when editing
    |> assign(:expanded_session_id, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Session")
    |> assign(:session, %Session{})
    |> assign(:changeset, Training.change_session(%Session{}))
    # Close expanded view when creating new
    |> assign(:expanded_session_id, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Training Sessions")
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
      hour = datetime.hour
      window_start = hour - rem(hour, 2)
      date = NaiveDateTime.to_date(datetime)
      # Keep as Date struct, don't convert to string
      {date, window_start}
    end)
    |> Enum.sort_by(fn {{date, window}, _sessions} ->
      # Sort by date descending, then by window descending
      {Date.to_gregorian_days(date) * -1, window * -1}
    end)
    |> Enum.map(fn {{date, window}, sessions} ->
      # Convert date to string only for the final output
      {{Date.to_string(date), window}, sessions}
    end)
    |> Map.new()
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
