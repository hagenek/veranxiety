defmodule VeranxietyWeb.ScheduleLive do
  use VeranxietyWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="bg-gradient text-black text-shadow p-4 rounded-md mb-16">
      <h2 class="text-xl font-bold">Dagplan</h2>

      <%= render_section(assigns, "Morgen", Time.new!(7, 0, 0), Time.new!(9, 0, 0),
        include_note: true
      ) %>
      <%= render_section(assigns, "Lunsj", Time.new!(11, 0, 0), Time.new!(13, 0, 0),
        include_note: true
      ) %>
      <%= render_section(assigns, "Ettermiddag", Time.new!(15, 0, 0), Time.new!(18, 0, 0),
        include_note: false
      ) %>
      <%= render_section(assigns, "Kveld", Time.new!(18, 0, 0), Time.new!(21, 0, 0),
        include_note: true
      ) %>
    </div>
    """
  end

  defp render_section(assigns, name, start_time, end_time, opts) do
    current_time = Time.utc_now()

    upcoming =
      Time.compare(current_time, start_time) != :lt and
        Time.compare(current_time, end_time) == :lt

    assigns =
      assigns
      |> assign(
        :section_class,
        if(upcoming,
          do: "text-lg font-semibold bg-yellow-200 p-2 rounded",
          else: "text-lg font-semibold text-gray-500"
        )
      )
      |> assign(:name, name)
      |> assign(:include_note, opts[:include_note])

    ~H"""
    <div class="mt-4">
      <h3 class={@section_class}><%= @name %></h3>
      <ul class="list-disc ml-6">
        <%= for item <- section_items(@name) do %>
          <li><%= item %></li>
        <% end %>
      </ul>
      <%= if @include_note do %>
        <p class="mt-2">
          Om hun er rolig, test å gå ut gjennom ytterdøren noen minutter fram og tilbake.
        </p>
      <% end %>
    </div>
    """
  end

  defp section_items("Morgen"),
    do: [
      "07-09 morgentur",
      "Alene i stuen",
      "Man kan gå innom av og til (maks 5 minutter), men ikke lengre opphold"
    ]

  defp section_items("Lunsj"),
    do: [
      "11-13 tur",
      "Alene i stuen",
      "Man kan gå innom av og til (maks 5 minutter), men ikke lengre opphold"
    ]

  defp section_items("Ettermiddag"),
    do: [
      "15-18 Vera trenger ikke være alene og går på tur",
      "Eventuelt forlenge til 16 dersom hun takler det fint"
    ]

  defp section_items("Kveld"),
    do: [
      "Mat 18-19",
      "19-21 lek og stimulering og går på tur",
      "Eventuelt forlenge til 16 dersom hun takler det fint"
    ]
end
