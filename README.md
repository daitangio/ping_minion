
# PingMinion

Erlang Elixir simple library to check site availability via http request
Is it my first Elixir project, so it is also a learning gym.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ping_minion to your list of dependencies in `mix.exs`:

        def deps do
          [{:ping_minion, "~> 0.0.2"}]
        end

  2. Ensure ping_minion is started before your application:

        def application do
          [applications: [:ping_minion]]
        end

## Usage
The most usual use case is to schedule a list of site to check:

    {:ok, server}=PingMinion.Scheduler.start_link()
    :ok = PingMinion.Scheduler.schedule(server,[ "http://gioorgi.com","http://IdonotexistIhopeforsureandsureandubuz.com/"])
    [ok: _time1, failed: _time2]  = PingMinion.Scheduler.ping(server)
    
Also, it is possible to save data on a csv based file for further
processing:

    {:ok, server}=PingMinion.Scheduler.start_link()
    :ok = PingMinion.Scheduler.schedule(server,[ "http://google.com"])
    PingMinion.Scheduler.pingAndStore(server,"ping-test-report.csv") 

The file wil have tre column: url, result and time taken in
microsecond (1^10-6 precision).
See the "simple csv encoding" test for a more complete example.

## Known issue
### hackney compilation trouble
If hackney/certifi compilation fails emitting an error like:

    ==> ping_minion
    ** (Mix) Could not compile dependency :hackney, "escript.exe "c:/Users/giorgig/.mix/rebar3" bare compile --paths "c:/giorgi/code/ping_minion/_build/dev/lib/*/ebin"" command failed. You can recompile this dependency with "mix deps.compile hackney", update it with "mix deps.update hackney" or clean it with "mix deps.clean hackney"

Try to download the latest rebar3 version and put under your $HOME/.mix/ home

## Interactive console (very useful during devel)
Under windows try out:

    IEX_WITH_WERL=true iex.bat -S mix


To generate the documentation try out

    mix.bat docs

Try out

    mix.bat xref unreachable


# Revision history

## 2016/06/28 Ping Minion 0.0.2 code name: "herbert"

*  Migrated to Elixir 1.3
*  Dependency update
*  Better documentation

## 2016/01/05 Ping Minion 0.0.1 code name: "yellow pop"

* First  Working Revision
