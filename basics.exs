defmodule Basics do

 def fact(0), do: 1
 def fact(n) when is_integer(n) and n > 0 do
   Enum.reduce (1..n), &(&1 * &2)
 end 

 def sum([])        , do: 0
 def sum([h | tail]), do: h + sum(tail)

 def accSum(list, initial \\0) when is_list(list) do
   Enum.reduce list, initial, &(&1 + &2)
 end
         
 def gcd(x, 0), do: x
 def gcd(x, y), do: gcd(y, rem(x,y)) 

 def type_of(x) when is_number(x) do
   IO.puts "#{x} is a number"
 end
 def type_of(x) when is_list(x) do
   IO.puts "#{inspect(x)} is a list"
 end
 def type_of(x) when is_atom(x) do
   IO.puts "#{x} is an atom"
 end

 def guess(target, first..last) when target >= first and target <= last do
    IO.puts "Searching in #{first}..#{last}"
    guess_helper(target, div(first + last, 2), first..last)
 end

 defp guess_helper(target, middle, _) when target == middle, do: middle
 defp guess_helper(target, middle, first.._) when middle > target do
   guess(target, first..(middle - 1))
 end
 defp guess_helper(target, middle, _..last) when middle < target do
   guess(target, (middle + 1)..last)
 end

end 
