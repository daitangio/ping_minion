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
      :failed
    end
  end
end
# Local variables:
# mode:elixir
# mode:company
# End:
