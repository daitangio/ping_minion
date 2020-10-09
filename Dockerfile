FROM elixir:1.9.4

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get 
RUN mix compile
RUN mix docs