defmodule VeranxietyWeb.Components.NavLinks do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def nav_links(assigns) do
    assigns = assign_new(assigns, :current_user, fn -> nil end)

    ~H"""
    <nav class="bg-surface dark:bg-surface-dark">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <div class="flex items-center">
            <a href="/" class="text-2xl font-bold text-text dark:text-text-dark">
              Veranxiety
            </a>
          </div>
          <div class="hidden md:block">
            <div class="ml-10 flex items-baseline space-x-4">
              <%= for link <- links(@current_user) do %>
                <.link
                  navigate={link.href}
                  class="text-text dark:text-text-dark hover:bg-surface-2 dark:hover:bg-surface-2-dark px-3 py-2 rounded-md text-sm font-medium"
                >
                  <%= link.label %>
                </.link>
              <% end %>
            </div>
          </div>
          <div class="md:hidden">
            <button
              phx-click={JS.toggle(to: "#mobile-menu")}
              class="inline-flex items-center justify-center p-2 rounded-md text-text dark:text-text-dark hover:bg-surface-2 dark:hover:bg-surface-2-dark focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
            >
              <span class="sr-only">Open main menu</span>
              <svg
                class="block h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 12h16M4 18h16"
                />
              </svg>
              <svg
                class="hidden h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <div class="md:hidden hidden" id="mobile-menu">
        <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
          <%= for link <- links(@current_user) do %>
            <.link
              navigate={link.href}
              class="text-text dark:text-text-dark hover:bg-surface-2 dark:hover:bg-surface-2-dark block px-3 py-2 rounded-md text-base font-medium"
              phx-click={JS.toggle(to: "#mobile-menu")}
            >
              <%= link.label %>
            </.link>
          <% end %>
        </div>
      </div>
    </nav>
    """
  end

  defp links(current_user) do
    public_links = [
      %{href: "/", label: "Dashboard"}
    ]

    authenticated_links = [
      %{href: "/sessions", label: "Training Log"},
      %{href: "/sessions/new", label: "Record Training"},
      %{href: "/allergy_entries", label: "Allergy Tracker"}
    ]

    auth_links = if current_user do
      [
        %{href: "#", label: current_user.email},
        %{href: "/users/settings", label: "Settings"},
        %{href: "/users/log_out", label: "Log out", method: :delete}
      ]
    else
      [
        %{href: "/users/register", label: "Register"},
        %{href: "/users/log_in", label: "Log in"}
      ]
    end

    if current_user do
      public_links ++ authenticated_links ++ auth_links
    else
      public_links ++ auth_links
    end
  end
end
