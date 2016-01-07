defmodule PingMinion do
  require Logger
  
  @doc """
  Starts a new Ping-orinented minion.
  """
  def start_link do
    # Our minion is a map %{} :) 
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Provide the url the minion must check
  """
  def url(minion, url2Check) do
    Agent.update(minion, &Map.put(&1, :url, url2Check))
    {:ok}
  end

  
  
  @doc """
   Use Erlang :timer.tc/1 function to get microseconds timing (1^10-6 precision)
   Do not provide error reason
  """
  def ping(minion) do
    {time, ret }= :timer.tc( fn() -> PingMinion.doPrivatePing(minion) end)
    {ret,time}
  end

  @doc """
   Internal ping function
  """
  def doPrivatePing(minion) do
    url = Agent.get(minion, &Map.get(&1, :url))
    Logger.info "Checking #{url}"
    response = HTTPotion.get url
    success=HTTPotion.Response.success?(response)
    if success ==true do
      :ok
    else
      #Logger.error "Failed #{response}"
      :failed
    end
  end
end

defmodule PingMinion.Scheduler do
  use GenServer
  require Logger
  
  #### Client API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  
  
  @doc """
  Client API:
  Schedule a list of url to check
  """
  def schedule(server, listOfUrls) do
    GenServer.cast(server, {:schedule,listOfUrls})
  end

  @doc """ 
  Client API: Do the check
  Returns `{:ok, pid}` if all ok, :error otherwise
  """
  def ping(server) do
    GenServer.call(server, {:ping})
  end

  

  # Server callbacks
  def init(:ok) do
    Logger.info "PingMinion.Scheduler ready"
    {:ok, %{ :url_list =>[] }}
  end

  # Async scheduler
  @doc """
   Collect the url(s) to check
  """
  def handle_cast({:schedule, urlList}, state) do
    Logger.debug "Adding #{urlList}"
    currentList =Map.get(state, :url_list)
    newList= currentList ++ urlList
    Logger.info "New Url List: #{newList}"
    newState=Map.put(state, :url_list, newList)
    {:noreply, newState}
  end


  # Sync check
  @doc """
   Simplest, sync check.
   Return a keyword list, with the time required:
    ok:     timeTakenMicroSeconds
    failed: timeTakenMicroseconds
  """
  def handle_call({:ping}, _from, state) do
    currentList =Map.get(state, :url_list)
    Logger.info "PING::: Checking #{currentList}"
    # Build a list of minions and loop async.
    # Then wait for results.    
    minions=Enum.map(currentList, fn(u) ->
      {:ok, bob } =PingMinion.start_link
      {:ok} = PingMinion.url(bob, u)
      bob
    end)
    ## This generate a keyword list
    results = Enum.reduce(minions,[], fn(m, acc) ->
      acc2=acc++ [ PingMinion.ping(m) ]
      acc2
    end)
    # results = Enum.map(minions, fn(m) -> PingMinion.ping(m) end)
    {:reply, results,  state}
  end
  
end
# Local variables:
# mode:elixir
# mode:company
# End:
