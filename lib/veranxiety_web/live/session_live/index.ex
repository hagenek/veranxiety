defmodule VeranxietyWeb.SessionLive.Index do
  use VeranxietyWeb, :live_view

  alias Veranxiety.Training
  alias Veranxiety.Training.Session

  def format_duration(duration) when is_integer(duration) do
    minutes = div(duration, 60)
    seconds = rem(duration, 60)
    "#{minutes} min #{seconds} sec"
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
    |> assign(:page_title, "Listing Session")
    |> assign(:session, nil)
    |> assign(:changeset, Training.change_session(%Session{}))
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Training.change_session(%Session{})

    {:ok,
     socket
     |> assign(:sessions, list_sessions())
     |> assign(:changeset, changeset)}
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

  defp convert_duration(params) do
    minutes = String.to_integer(params["duration_minutes"] || "0")
    seconds = String.to_integer(params["duration_seconds"] || "0")
    total_seconds = minutes * 60 + seconds
    Map.put(params, "duration", total_seconds)
  end

  def handle_event("save", %{"session" => session_params}, socket) do
    session_params = convert_duration(session_params)

    case Training.create_session(session_params) do
      {:ok, _session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Session created successfully")
         |> assign(:sessions, list_sessions())
         |> assign(:changeset, Training.change_session(%Session{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp list_sessions do
    Training.list_sessions()
  end
end
