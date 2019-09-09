defmodule Ticker do

  @interval 2000 #ms
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def generator(clients) do
    receive do
      {:register, pid} ->
        IO.puts "registering #{inspect pid}"
        generator([pid | clients])
    after @interval ->
      IO.puts "tick"
      if clients != [] do send hd(clients), {:tick} end
    end
    clients |> rotate_left |> generator
  end

  defp rotate_left([]) do
    []
  end
  defp rotate_left([h | tail]) do
    tail ++ [h]
  end

end

defmodule Client do

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts "tock in #{inspect self()}"
        receiver()
    end
  end

end
