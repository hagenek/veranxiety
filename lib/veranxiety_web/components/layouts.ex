defmodule VeranxietyWeb.Layouts do
  use VeranxietyWeb, :html

  embed_templates "layouts/*"

  def app(assigns) do
    ~H"""
    <div class="flex flex-col h-screen overflow-hidden dark:text-rose bg-base dark:bg-base-dark">
      <header class="flex-none bg-surface dark:bg-surface-dark shadow z-10">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8 flex justify-between items-center">
          <nav>
            <.nav_links />
          </nav>
          <button
            id="dark-mode-toggle"
            class="text-gray-500 p-2 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
              />
            </svg>
          </button>
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
