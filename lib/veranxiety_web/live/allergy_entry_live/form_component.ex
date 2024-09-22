defmodule VeranxietyWeb.AllergyEntryLive.FormComponent do
  use VeranxietyWeb, :live_component

  alias Veranxiety.Allergy

  @impl true
  def update(%{entry: entry} = assigns, socket) do
    changeset = Allergy.change_entry(entry)
    today = Date.utc_today()

    changeset = Ecto.Changeset.put_change(changeset, :date, today)

    IO.inspect(changeset, label: "Changeset after update")
    IO.inspect(Ecto.Changeset.get_field(changeset, :date), label: "Date field value")

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"entry" => entry_params}, socket) do
    changeset =
      socket.assigns.entry
      |> Allergy.change_entry(entry_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"entry" => entry_params}, socket) do
    save_entry(socket, socket.assigns.action, entry_params)
  end

  defp save_entry(socket, :edit, entry_params) do
    case Allergy.update_entry(socket.assigns.entry, entry_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Allergy entry updated successfully")
         |> push_navigate(to: ~p"/allergy_entries")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_entry(socket, :new, entry_params) do
    case Allergy.create_entry(entry_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Allergy entry created successfully")
         |> push_navigate(to: ~p"/allergy_entries")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
