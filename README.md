# Veranxiety

To start your Phoenix server:

- Setup a database with e.g. docker

```zsh
  Docker command for PostgreSQL 17 setup

  docker run --name veranxiety-postgres \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=veranxiety_dev \
    -p 5432:5435 \
    -d postgres:17
```

## Features to implement

### Add options for inserting

- [ ] Boxes for what room dog is in.
- [ ] Listening to podcast or music in background?
- [ ] Activity before leaving dog.

### Grouping, view logic
- [ ] Add grouping of training sessions.

### Data shown is from "dog" not tied to user

- [ ] Scope this.

## Fixes needed

- [ ] When clicking outside of checkbox not succesful, it is not chosen visually. (Arc browser)
- [ ]

### Special for wsl2

```zsh
    /home/hagenek/.asdf/installs/postgres/17.0/bin/pg_ctl -D /home/hagenek/.asdf/installs/postgres/17.0/data -l logfile starV
```

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

deployed at https://veranxiety.fly.dev
