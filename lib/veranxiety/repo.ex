defmodule Veranxiety.Repo do
  use Ecto.Repo,
    otp_app: :veranxiety,
    adapter: Ecto.Adapters.Postgres
end
