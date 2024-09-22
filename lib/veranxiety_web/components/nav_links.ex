defmodule VeranxietyWeb.Components.NavLinks do
  use Phoenix.Component
  use VeranxietyWeb, :verified_routes

  def nav_links(assigns) do
    ~H"""
    <ul class="flex space-x-4">
      <li>
        <.link
          navigate={~p"/"}
          class="text-gray-700 hover:text-gray-900 dark:text-gray-300 dark:hover:text-gray-100"
        >
          Home
        </.link>
      </li>
      <li>
        <.link
          navigate={~p"/sessions"}
          class="text-gray-700 hover:text-gray-900 dark:text-gray-300 dark:hover:text-gray-100"
        >
          Sessions
        </.link>
      </li>
      <li>
        <.link
          navigate={~p"/sessions/new"}
          class="text-gray-700 hover:text-gray-900 dark:text-gray-300 dark:hover:text-gray-100"
        >
          New Session
        </.link>
      </li>
      <li>
        <.link
          navigate={~p"/allergy_entries"}
          class="text-gray-700 hover:text-gray-900 dark:text-gray-300 dark:hover:text-gray-100"
        >
          Allergies
        </.link>
      </li>
    </ul>
    """
  end
end
