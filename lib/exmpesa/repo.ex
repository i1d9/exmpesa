defmodule Exmpesa.Repo do
  use Ecto.Repo,
    otp_app: :exmpesa,
    adapter: Ecto.Adapters.Postgres
end
