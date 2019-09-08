defmodule FibSolver do

  def fib(scheduler_pid) do
    send scheduler_pid, {:ready, self()}
    receive do
      {:fib, n, client} ->
        send client, {:answer, n, fib_calc(n), self()}
        fib(scheduler_pid)
      {:shutdown} ->
        exit(:normal)
    end
  end

  #deliberately inefficient
  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n - 1) + fib_calc(n - 2)

end

defmodule Scheduler do

  def run(number_of_processes, module, fun, items_to_calculate) do
    (1..number_of_processes)
    |> Enum.map(fn _ -> spawn(module, fun, [self()])end)
    |> schedule_processes(items_to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, client} when queue != [] ->
        [head | tail] = queue
        send client, {:fib, head, self()}
        schedule_processes(processes, tail, results)

      {:ready, client} ->
        send client, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(processes |> List.delete(client), queue, results)
        else
          results |> Enum.sort(fn {n, _}, {m, _} -> n <= m end)
        end

      {:answer, number, result, _client} ->
        schedule_processes(processes, queue, [{number, result} | results])
    end
  end

end

nums_to_calculate = List.duplicate(37, 20)
Enum.each(1..10, fn n ->
  {time, _result} = :timer.tc(Scheduler,
                              :run,
                              [n, FibSolver, :fib, nums_to_calculate])
  :io.format "~2B     ~.2f~n", [n, time/1000000.0]
end)

