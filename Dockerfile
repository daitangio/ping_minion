FROM elixir:1.9.4


RUN mkdir -p /app

COPY . /app/
WORKDIR /app/

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get 
RUN mix compile
# Got an error during docs rendering
# RUN mix docs

