FROM elixir:1.13.4

RUN addgroup --gid 1000 dev
RUN adduser --system --uid 1000 --gid 1000 dev  --shell /bin/bash --home /home/dev
USER 1000:1000
# WORKDIR /workspaces/ping_minion

# RUN mix local.hex --force && mix local.rebar --force && mix deps.get 
#WORKDIR /.mix

# RUN mix compile
# RUN mix docs

