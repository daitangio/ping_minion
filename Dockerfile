FROM elixir:1.13.4


WORKDIR /app/

COPY . /app/

RUN mix local.hex --force && mix local.rebar --force && mix deps.get 
RUN mix compile
RUN mix docs

