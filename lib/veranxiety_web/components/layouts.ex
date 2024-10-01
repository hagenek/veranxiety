defmodule VeranxietyWeb.Layouts do
  use VeranxietyWeb, :html

  embed_templates "layouts/*"
  alias VeranxietyWeb.Components.BottomNav
  alias VeranxietyWeb.Components.DarkLightToggle

  def app(assigns) do
    ~H"""
    <div class="flex flex-col h-screen overflow-hidden dark:text-rose bg-base dark:bg-base-dark">
      <header class="flex-none bg-surface dark:bg-surface-dark md:shadow z-10">
        <div class="max-w-7xl mx-auto py-2 px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between items-center">
            <div class="flex items-center space-x-4">
            <DarkLightToggle.dark_light_toggle />
              <a href="/" class="text-2xl font-bold text-text dark:text-text-dark">
                Veranxiety
              </a>
            </div>
            <.nav_links current_user={@current_user} />
          </div>
        </div>
      </header>

      <main class="flex-1 overflow-y-auto">
        <div class="max-w-7xl mt-4 mx-0 px-2 sm:mx-auto py-0 md:py-6 sm:px-6 lg:px-8">
          <%= @inner_content %>
        </div>
      </main>
      <BottomNav.bottom_nav />
      <footer class="bg-surface dark:bg-surface-dark py-4 text-center text-sm text-gray-500 dark:text-gray-400">
        <p>&copy; <%= DateTime.utc_now().year %> Veranxiety. All rights reserved.</p>
      </footer>
    </div>
    """
  end
end
