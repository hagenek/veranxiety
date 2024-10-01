defmodule VeranxietyWeb.UserRegistrationLive do
  use VeranxietyWeb, :live_view

  alias Veranxiety.Accounts
  alias Veranxiety.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm bg-white mt-4 dark:bg-gray-800 text-gray-900 dark:text-gray-100">
      <.header class="text-center dark:text-gray-200">
        Register for an account
        <:subtitle>
          Already registered?
          <.link
            navigate={~p"/users/log_in"}
            class="font-semibold text-brand dark:text-peach hover:underline"
          >
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
        class="p-4 rounded-lg dark:bg-gray-900"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input
          field={@form[:email]}
          type="email"
          label="email"
          required
          class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100"
        />
        <.input
          field={@form[:password]}
          type="password"
          label="password"
          required
          class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100"
        />

        <:actions>
          <.button
            phx-disable-with="Creating account..."
            class="w-full bg-brand dark:bg-surface-1 text-white dark:text-peach"
          >
            Create an account
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
