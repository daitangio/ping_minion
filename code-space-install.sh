#!/bin/bash
sudo apt install -y elixir
mix local.hex --force
mix deps.get
mix deps.compile
