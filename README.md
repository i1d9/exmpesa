# Exmpesa

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Local Tests

Create dev.secret.exs
```elixir

import Config


config :mpesa_api,
  consumer_key: "YOUR KEY",
  consumer_secret: "YOUR SECRET",
  call_back_url: "",
  online_pass_key: "YOUR PASS KEY",
  online_short_code: "YOUR ONLINE SHORT CODE"

```