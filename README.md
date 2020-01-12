# Phlog

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Docker

The project was initialized with the included docker configuration:
* `docker-compose build`
* `docker-compose run --no-deps app mix phx.new --app phlog --module Phlog .`

**NOTE** the Dockerfile creates a user in the container. the UID and GID should
match the host user values so files created will have proper ownership.
