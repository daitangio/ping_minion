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
  Return the url 
  """
  def url(minion) do
    Agent.get(minion, &Map.get(&1, :url))
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
    try do
      # GG Eval adding timeout....but below 5secs because gen server seems to have timeouts
      #options= [ :timeout , 4000 ]
      #response = HTTPotion.get url, options
      response = HTTPotion.get url
      success=HTTPotion.Response.success?(response)
      if success ==true do
        :ok
      else
        #Logger.error "Failed #{response}"
        :failed
      end
    rescue
      HTTPotion.HTTPError ->
        Logger.error "HTTPotion.HTTPError for #{url}" ;  :failed
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

  @doc """
  Use Quantum to schedule a job every minute
  """
  def cronSchedule(urls, jobNameAtom) do
    {:ok, server}=PingMinion.Scheduler.start_link()
    :ok = PingMinion.Scheduler.schedule(server,urls)
    job_spec = [
      schedule: "* * * * *",
      task: fn(s) ->  PingMinion.Scheduler.ping(s)  end,
      args: [server],
      overlap: false
    ]
    Quantum.add_job(jobNameAtom,job_spec)
  end

  @doc """
  Ping the files and store the result on the specified file
  """
  def pingAndStore(server, file2Append) do
    GenServer.call(server, {:pingAndStore, file2Append })
  end

  # Server callbacks
  # ###########################################
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

  def handle_call({:pingAndStore, file2Append}, _from, state ) do
    require CSV
    currentList =Map.get(state, :url_list)
    Logger.info "PING and Store::: Checking #{currentList}"
    # Build a list of minions and loop async.
    # Then wait for results.    
    minions=Enum.map(currentList, fn(u) ->
      {:ok, bob } =PingMinion.start_link
      {:ok} = PingMinion.url(bob, u)
      bob
    end)
    
    file=File.open!(file2Append, [:append, :utf8 ])

    results=Enum.reduce(minions,[], fn(m,acc) ->
      {result, timeTaken} = PingMinion.ping(m)
      acc ++ [ [ PingMinion.url(m), result, timeTaken]]
      end)
    
    results |>
      CSV.encode(separator: ?;, delimiter: "\n") |>
      Enum.each(&IO.write(file, &1))
    {:reply, results,  state}
  end
  
end
# Local variables:
# mode:elixir
# mode:company
# End:
