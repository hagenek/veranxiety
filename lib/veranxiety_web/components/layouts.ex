defmodule VeranxietyWeb.Layouts do
  use VeranxietyWeb, :html

  embed_templates "layouts/*"

  def app(assigns) do
    ~H"""
    <div class="min-h-full">
      <header class="bg-white shadow">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 class="text-3xl font-bold text-gray-900"><%= @page_title %></h1>
        </div>
      </header>
      <main>
        <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
          <%= @inner_content %>
        </div>
      </main>
    </div>
    """
  end
end
