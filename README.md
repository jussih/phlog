# Phlog

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Docker

### How this project was created

The project was initialized with the included docker configuration:
* `docker-compose build`
* `docker-compose run --no-deps app mix phx.new --app phlog --module Phlog .`

**NOTE** the Dockerfile creates a user in the container. the UID and GID should
match the host user values so files created will have proper ownership.

### How to use

- `docker-compose up`
- `docker-compose exec app npm install --prefix ./assets`
- `docker-compose exec app mix ecto.migrate` to create database tables

### Release
- `docker-compose exec app mix deps.get --only prod`
- `docker-compose exec -e MIX_ENV=prod app mix compile`
- `docker-compose exec app npm run deploy --prefix ./assets`
- `docker-compose exec app mix phx.digest`
- `docker-compose exec -e MIX_ENV=prod app mix release`

### Deploy
- Move `_build/prod/rel/phlog/` to the server
- Start app `bin/phlog start`
- Run migrations `bin/phlog eval "Phlog.Release.migrate"`
- Render docs to db `bin/phlog eval "Phlog.Release.render_docs"`
