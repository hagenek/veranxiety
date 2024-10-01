defmodule VeranxietyWeb.Components.NavLinks do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def nav_links(assigns) do
    assigns = assign_new(assigns, :current_user, fn -> nil end)

    ~H"""
    <nav class="relative z-10">
      <div class="hidden md:flex space-x-8">
        <%= for link <- links(@current_user) do %>
          <.link
            navigate={link.href}
            class="veranxiety-menu-item text-gray-800 dark:text-white hover:text-yellow-600 dark:hover:text-yellow-300 font-semibold"
          >
            <%= link.label %>
          </.link>
        <% end %>
      </div>
      <div class="md:hidden">
        <button
          phx-click={JS.toggle(to: "#mobile-menu") |> JS.toggle(to: "#menu-open") |> JS.toggle(to: "#menu-close")}
          class="veranxiety-menu-button z-50 relative"
          aria-label="Toggle menu"
        >
          <svg
            id="menu-open"
            xmlns="http://www.w3.org/2000/svg"
            class="h-8 w-8 text-gray-800 dark:text-white"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
          <svg
            id="menu-close"
            xmlns="http://www.w3.org/2000/svg"
            class="h-8 w-8 text-gray-800 dark:text-white hidden"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
      <div
        id="mobile-menu"
        class="md:hidden fixed inset-0 bg-white dark:bg-gray-800 bg-opacity-95 dark:bg-opacity-95 z-40 flex-col items-center justify-center hidden"
        phx-click-away={JS.hide(to: "#mobile-menu") |> JS.show(to: "#menu-open") |> JS.hide(to: "#menu-close")}
      >
        <div class="flex flex-col items-center justify-center h-full">
          <%= for link <- links(@current_user) do %>
            <.link
              navigate={link.href}
              class="veranxiety-menu-item text-gray-800 dark:text-white hover:text-yellow-600 dark:hover:text-yellow-300 font-semibold text-2xl mb-6"
              phx-click={JS.hide(to: "#mobile-menu") |> JS.show(to: "#menu-open") |> JS.hide(to: "#menu-close")}
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
      %{href: "/", label: "Dashboard"},
    ]

    authenticated_links = [
      %{href: "/sessions", label: "Anxiety Training"},
      %{href: "/allergy_entries", label: "Allergy Tracking"}
    ]

    auth_links =
      if current_user do
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
