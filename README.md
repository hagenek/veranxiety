# Veranxiety

To start your Phoenix server:

- Setupa a database with e.g. docker

```zsh
  Docker command for PostgreSQL 16 setup

  docker run --name veranxiety-postgres \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=veranxiety_dev \
    -p 5432:5432 \
    -d postgres:17
```

### Special for wsl2

```zsh
    /home/hagenek/.asdf/installs/postgres/17.0/bin/pg_ctl -D /home/hagenek/.asdf/installs/postgres/17.0/data -l logfile starV
```

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## TODOs

- [ ] Make sure the app works as expected and that navigation is possible
  - [ ] Add a link to the homepage

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
