defmodule VeranxietyWeb.SessionLive.Index do
  use VeranxietyWeb, :live_view

  alias Veranxiety.Training
  alias Veranxiety.Training.Session

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Session")
    |> assign(:session, Training.get_session!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Session")
    |> assign(:session, %Session{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Vera's Anxiety Separation Training")
    |> assign(:session, nil)
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:sessions, list_sessions())
     |> assign(:new_session, Training.change_session(%Session{}))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    session = Training.get_session!(id)
    {:ok, _} = Training.delete_session(session)

    {:noreply, assign(socket, :sessions, list_sessions())}
  end

  def handle_event("save", %{"session" => session_params}, socket) do
    case Training.create_session(session_params) do
      {:ok, _session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Session created successfully")
         |> assign(:sessions, list_sessions())
         |> assign(:new_session, Training.change_session(%Session{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :new_session, changeset)}
    end
  end

  defp list_sessions do
    Veranxiety.Training.list_sessions()
  end
end
