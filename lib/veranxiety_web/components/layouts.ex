defmodule VeranxietyWeb.Layouts do
  use VeranxietyWeb, :html

  embed_templates "layouts/*"

  def app(assigns) do
    ~H"""
    <div class="min-h-full dark:text-rose bg-base dark:bg-base-dark">
      <header class="bg-surface dark:bg-surface-dark shadow">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 class="text-3xl font-bold text-text dark:text-text-dark">Veranxiety</h1>
        </div>
      </header>
      <main>
        <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 dark:text-">
          <%= @inner_content %>
        </div>
      </main>
    </div>
    """
  end
end
