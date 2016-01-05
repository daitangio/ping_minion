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
    
  end
  
end
# Local variables:
# mode:elixir
# mode:company
# End:
