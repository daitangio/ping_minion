# PingMinion

Erlang Elixir simple library to check site availability.
Is it my first Elixir project, so it is also a learning gym.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ping_minion to your list of dependencies in `mix.exs`:

        def deps do
          [{:ping_minion, "~> 0.0.1"}]
        end

  2. Ensure ping_minion is started before your application:

        def application do
          [applications: [:ping_minion]]
        end

## Usage
(TODO) See Unit test
## Interactive console (very useful during devel)
Under windows try out:

    IEX_WITH_WERL=true iex.bat -S mix

To generate the documentation try out

    mix.bat docs
