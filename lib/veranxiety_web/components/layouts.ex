defmodule VeranxietyWeb.Layouts do
  use VeranxietyWeb, :html

  embed_templates "layouts/*"

  def app(assigns) do
    ~H"""
    <div class="flex flex-col h-screen overflow-hidden dark:text-rose bg-base dark:bg-base-dark">
    <header class="flex-none bg-surface dark:bg-surface-dark md:shadow z-10">
  <div class="max-w-7xl mx-auto py-2 px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center">
      <div class="flex items-center space-x-4">
        <button
          id="dark-mode-toggle"
          x-data="{ darkMode: localStorage.getItem('darkMode') === 'true' || window.matchMedia('(prefers-color-scheme: dark)').matches }"
          x-init="$watch('darkMode', value => { document.documentElement.classList.toggle('dark', value); localStorage.setItem('darkMode', value); })"
          @click="darkMode = !darkMode"
          class="text-gray-500 p-2 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            x-show="darkMode"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
            />
          </svg>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            x-show="!darkMode"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
            />
          </svg>
        </button>
        <a href="/" class="text-2xl font-bold text-text dark:text-text-dark">
          Veranxiety
        </a>
      </div>
      <div class="hidden md:block">
        <.nav_links current_user={@current_user} />
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
        </button>
      </div>
    </div>
  </div>
  <div class="md:hidden hidden" id="mobile-menu">
    <.nav_links current_user={@current_user} />
  </div>
</header>

      <main class="flex-1 overflow-y-auto">
        <div class="max-w-7xl mx-0 px-2 sm:mx-auto py-0 md:py-6 sm:px-6 lg:px-8">
          <%= @inner_content %>
        </div>
      </main>
      <footer class="bg-surface dark:bg-surface-dark py-4 text-center text-sm text-gray-500 dark:text-gray-400">
        <p>&copy; <%= DateTime.utc_now().year %> Veranxiety. All rights reserved.</p>
      </footer>
    </div>
    """
  end
end
