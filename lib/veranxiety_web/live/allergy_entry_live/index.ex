# File: ./veranxiety_web/live/allergy_entry_live/index.ex

defmodule VeranxietyWeb.AllergyEntryLive do
  use VeranxietyWeb, :live_view
  alias Veranxiety.Allergy
  alias Veranxiety.Allergy.Entry

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    entries = list_entries(current_user)
    most_recent_entry = Allergy.get_most_recent_entry(current_user)

    {:ok,
     socket
     |> assign(:entries, entries)
     |> assign(:itch_score, nil)
     |> assign(:symptoms, [])
     |> assign(:current_user, current_user)
     |> assign(:current_food, most_recent_entry && most_recent_entry.current_food)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    entry = Allergy.get_entry!(current_user, id)
    {:ok, _} = Allergy.delete_entry(current_user, entry)
    {:noreply, assign(socket, :entries, list_entries(current_user))}
  end

  @impl true
  def handle_event("validate", %{"entry" => entry_params}, socket) do
    changeset =
      socket.assigns.entry
      |> Allergy.change_entry(entry_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:current_food, entry_params["current_food"] || socket.assigns.current_food)}
  end

  @impl true
  def handle_event("save", %{"entry" => entry_params}, socket) do
    updated_params =
      Map.merge(entry_params, %{
        "itch_score" => socket.assigns.itch_score,
        "symptoms" => Enum.join(socket.assigns.symptoms, ", "),
        "current_food" => entry_params["current_food"] || socket.assigns.current_food
      })

    save_entry(socket, socket.assigns.live_action, updated_params)
  end

  @impl true
  def handle_event("set_itch_score", %{"score" => score}, socket) do
    {:noreply, assign(socket, :itch_score, String.to_integer(score))}
  end

  @impl true
  def handle_event("toggle_symptom", %{"symptom" => symptom}, socket) do
    updated_symptoms =
      if symptom in socket.assigns.symptoms do
        List.delete(socket.assigns.symptoms, symptom)
      else
        [symptom | socket.assigns.symptoms]
      end

    {:noreply, assign(socket, :symptoms, updated_symptoms)}
  end

  @impl true
  def handle_event("navigate_back", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/allergy_entries")}
  end

  defp format_date(date) do
    Calendar.strftime(date, "%a %d. %B %Y")
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    current_user = socket.assigns.current_user
    entry = Allergy.get_entry!(current_user, id)

    socket
    |> assign(:page_title, "Edit Allergy Entry")
    |> assign(:entry, entry)
    |> assign(:changeset, Allergy.change_entry(entry))
  end

  defp apply_action(socket, :new, _params) do
    today = Date.utc_today()
    # Add default empty string
    entry = %Entry{date: today, current_food: socket.assigns.current_food || ""}

    socket
    |> assign(:page_title, "New Allergy Entry")
    |> assign(:entry, entry)
    |> assign(:changeset, Allergy.change_entry(entry))
  end

  defp apply_action(socket, :index, _params) do
    current_user = socket.assigns.current_user

    socket
    |> assign(:page_title, "Allergy Entries")
    |> assign(:entry, nil)
    |> assign(:entries, list_entries(current_user))
    |> assign(:changeset, nil)
  end

  defp save_entry(socket, :edit, entry_params) do
    current_user = socket.assigns.current_user

    case Allergy.update_entry(current_user, socket.assigns.entry, entry_params) do
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
    current_user = socket.assigns.current_user

    case Allergy.create_entry(current_user, entry_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Allergy entry created successfully")
         |> push_navigate(to: ~p"/allergy_entries")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp list_entries(current_user) do
    Allergy.list_allergy_entries(current_user)
  end

  defp itch_score_classes(score) do
    base_classes = "mt-2 px-3 py-1 w-fit text-xs font-semibold rounded-full"

    score_specific_classes =
      case score do
        0 -> "bg-green text-crust dark:bg-green dark:text-base"
        1 -> "bg-yellow text-crust dark:bg-yellow dark:text-base"
        2 -> "bg-peach text-crust dark:bg-peach dark:text-base"
        3 -> "bg-red text-crust dark:bg-maroon dark:text-base"
        4 -> "bg-mauve text-crust dark:bg-red dark:text-base"
        _ -> "bg-surface0 text-text dark:bg-surface1 dark:text-text"
      end

    "#{base_classes} #{score_specific_classes}"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-7xl mx-auto px-0 sm:px-4 lg:px-8">
      <div class="bg-base dark:bg-base shadow-xl rounded-lg overflow-hidden">
        <%= if @live_action in [:new, :edit] do %>
          <div class="px-4 py-5 sm:p-6">
            <!-- Back Button -->
            <div class="mb-4">
              <button
                type="button"
                phx-click="navigate_back"
                class="flex items-center text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300"
              >
                <svg
                  class="w-6 h-6 mr-1"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 19l-7-7 7-7"
                  >
                  </path>
                </svg>
                Back
              </button>
            </div>

            <.form
              :let={f}
              for={@changeset}
              phx-submit="save"
              phx-change="validate"
              class="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md space-y-6"
            >
              <div>
                <.input
                  field={f[:date]}
                  type="date"
                  label="Date (required)"
                  value={Phoenix.HTML.Form.input_value(f, :date)}
                  class="mt-2 block w-full rounded-lg text-zinc-900 dark:bg-base dark:text-black focus:ring-0 sm:text-sm sm:leading-6 border-zinc-300 focus:border-zinc-400"
                  required
                />
              </div>

              <div>
                <.input
                  field={f[:current_food]}
                  type="text"
                  label="Current Food"
                  value={@current_food}
                  phx-update="ignore"
                  class="mt-2 block w-full rounded-lg text-zinc-900 dark:bg-base dark:text-black focus:ring-0 sm:text-sm sm:leading-6 border-zinc-300 focus:border-zinc-400"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-lavender mb-2">
                  Itch Score (required)
                </label>
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-2">
                  <%= for {score, label} <- [{0, "never"}, {1, "rarely"}, {2, "sometimes"}, {3, "often"}, {4, "excessively"}] do %>
                    <button
                      type="button"
                      phx-click="set_itch_score"
                      phx-value-score={score}
                      class={"w-full px-3 py-2 text-sm font-medium rounded-md transition-colors duration-150 ease-in-out #{
    if @itch_score == score do
    "bg-mauve text-base dark:bg-blue dark:text-crust"
    else
    "bg-surface0 text-text hover:bg-surface1 dark:bg-surface1 dark:text-lavender dark:hover:bg-surface2"
    end
    } border border-surface1 dark:border-surface2"}
                    >
                      <span class="capitalize"><%= label %> (<%= score %>)</span>
                    </button>
                  <% end %>
                </div>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Symptoms (optional)
                </label>
                <div class="space-y-3">
                  <%= for symptom <- ["Scratching", "Licking paws", "Ear inflammation", "Skin redness"] do %>
                    <div class="flex items-center">
                      <input
                        type="checkbox"
                        id={symptom}
                        name="symptoms[]"
                        value={symptom}
                        checked={symptom in @symptoms}
                        phx-click="toggle_symptom"
                        phx-value-symptom={symptom}
                        class="w-6 h-6 text-blue bg-surface0 border-surface1 rounded focus:ring-blue"
                      />
                      <label for={symptom} class="ml-3 text-sm text-gray-700 dark:text-gray-300">
                        <%= symptom %>
                      </label>
                    </div>
                  <% end %>
                </div>
              </div>

              <div>
                <.input
                  field={f[:notes]}
                  type="textarea"
                  label="Additional Notes (optional)"
                  rows="4"
                  class="mt-1 block w-full rounded-lg text-zinc-900 dark:bg-base dark:text-sky focus:ring-0 sm:text-sm sm:leading-6 border-zinc-300 focus:border-zinc-400"
                />
              </div>

              <div class="mt-4 flex justify-between px-8">
                <.button class="dark:bg-red dark:text-white" phx-click="navigate_back">
                  Cancel
                </.button>
                <.button class="transition-colors duration-200
    light:bg-fuchsia-400 light:hover:bg-fuchsia-500 light:text-purple-900
    light:border-2 light:border-pink-300 light:hover:border-pink-400
    dark:bg-[#89b4fa] dark:hover:bg-[#74c7ec] dark:text-[#1e1e2e]
    font-medium rounded-lg px-4 py-2 text-sm">
                  <%= if @live_action == :new, do: "Add Entry", else: "Update Entry" %>
                </.button>
              </div>
            </.form>
          </div>
        <% else %>
          <div class="px-4 py-5 sm:p-6">
            <div class="mb-6 flex justify-between items-center">
              <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">Allergy Entries</h3>
              <.link patch={~p"/allergy_entries/new"}>
                <.button class="dark:bg-mauve dark:text-black">
                  <span>New Entry</span>
                  <.icon name="hero-plus-circle-mini" class="ml-2 h-5 w-5" />
                </.button>
              </.link>
            </div>
            <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
              <%= for entry <- @entries do %>
                <div class="bg-white dark:bg-gray-800 shadow rounded-lg p-6 space-y-4">
                  <div class="flex-col justify-between items-center">
                    <div class="text-sm font-semibold text-gray-900 dark:text-gray-100">
                      <%= format_date(entry.date) %>
                    </div>
                    <div class={itch_score_classes(entry.itch_score)}>
                      Itch Score: <%= entry.itch_score %>
                    </div>
                  </div>
                  <p class="text-sm text-gray-600 dark:text-gray-300">
                    <strong>Symptoms:</strong> <%= entry.symptoms || "None reported" %>
                  </p>
                  <p class="text-sm text-gray-600 dark:text-gray-300">
                    <strong>Current Food:</strong> <%= entry.current_food || "Not specified" %>
                  </p>
                  <%= if entry.notes && entry.notes != "" do %>
                    <p class="text-sm text-gray-600 dark:text-gray-300">
                      <strong>Notes:</strong> <%= entry.notes %>
                    </p>
                  <% end %>
                  <div class="flex justify-end space-x-2">
                    <.link
                      patch={~p"/allergy_entries/#{entry.id}/edit"}
                      class="text-indigo-600 hover:text-indigo-900 dark:text-indigo-400 dark:hover:text-indigo-300"
                    >
                      <.icon name="hero-pencil-square-mini" class="h-7 w-7" />
                    </.link>
                    <.link
                      phx-click="delete"
                      phx-value-id={entry.id}
                      data-confirm="Are you sure you want to delete this entry?"
                      class="text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-300"
                    >
                      <.icon name="hero-trash-mini" class="h-7 w-7" />
                    </.link>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
