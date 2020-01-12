defmodule Phlog.Repo do
  use Ecto.Repo,
    otp_app: :phlog,
    adapter: Ecto.Adapters.Postgres
end
