defmodule VeranxietyWeb.Components.BottomNav do
  use Phoenix.Component
  use VeranxietyWeb, :live_view

  def bottom_nav(assigns) do
    ~H"""
    <nav class="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 shadow-lg z-50 md:hidden">
      <div class="flex justify-around items-center h-20">
        <.nav_item route="/schedule" icon="hero-calendar-solid" label="Dashboard" />
        <.nav_item route="/sessions" icon="hero-academic-cap-solid" label="Anxiety Training" />
        <.nav_item route="/allergy_entries" icon="hero-bug-ant-solid" label="Allergy Tracking" />
        <.nav_item route="/users/settings" icon="hero-cog-6-tooth-solid" label="Settings" />
      </div>
    </nav>
    """
  end

  defp nav_item(assigns) do
    ~H"""
    <.link
      navigate={@route}
      class="flex items-center justify-center w-full h-full text-gray-600 hover:text-blue-500 dark:text-gray-300 dark:hover:text-blue-400 transition-colors duration-200"
      aria-label={@label}
    >
      <.icon name={@icon} class="h-8 w-8" />
    </.link>
    """
  end
end
