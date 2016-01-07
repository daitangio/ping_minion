defmodule PingMinionTest do
  use ExUnit.Case, async: true  
  doctest PingMinion

  setup do
    {:ok, fred } =PingMinion.start_link
    {:ok, minion: fred}
  end

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "the false" do
       assert 1+1 !=3
  end
  test "you can add a site to monitor", %{minion: fred } do
    assert PingMinion.url(fred,"http://gioorgi.com") == {:ok}
  end

  test "you can monitor", %{minion: fred } do
    PingMinion.url(fred,"http://gioorgi.com")
    {:ok,timeRequiredMicroseconds} = PingMinion.ping(fred)
    # 1 Microseconds = 1^10-6 seconds
    # 1 milliseconds = 1000microseconds
    assert timeRequiredMicroseconds < 5000* 1000
  end

  test "nonexistent site cannot be pinged", %{minion: fred } do
    PingMinion.url(fred,"http://IdonotexistIhopeforsureandsureandubuz.com")
    { result, _ } = PingMinion.ping(fred)
    assert result== :failed
  end

  # I must decide the api: link  minions, group them?.... bhof....
  # Also the API should hide the GenServer protocol (if needed) 
  test "spawn minions" do
    # Schedule every minute a list of stuff
    {:ok, server}=PingMinion.Scheduler.start_link()
    :ok = PingMinion.Scheduler.schedule(server,[ "http://gioorgi.com", "http://IdonotexistIhopeforsureandsureandubuz.com/"])
    # How to assert it?
    [ok: _time1, failed: _time2]  = PingMinion.Scheduler.ping(server)
  end

  test "simple csv encoding" do
    require CSV
    file = File.open!("test.csv", [:write])
    [  ~w( URL RESULT MICROSECONDS),
       ["Gioorgi.com", "ok", "2000000"] ] |>
      CSV.encode(separator: ?;, delimiter: "\n") |>
      Enum.each(&IO.write(file, &1))
  end

  test "simple storing" do
    ## TODO REMOVE FILE BEFORE TEST
    {:ok, server}=PingMinion.Scheduler.start_link()
    :ok = PingMinion.Scheduler.schedule(server,[ "http://gioorgi.com", "http://IdonotexistIhopeforsureandsureandubuz.com/"])
    PingMinion.Scheduler.pingAndStore(server,"ping-test-report.csv")
    ## TODO CHECK FILE EXISTS!
  end
end
# Local variables:
# mode:elixir
# mode:company
# End:
