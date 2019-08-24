defmodule MyList do

  def is_empty([]), do: true
  def is_empty(l) when is_list(l), do: false

  def head([]), do: nil
  def head([h | _]), do: h

  def last([]), do: nil
  def last([x]), do: x
  def last([_ | tail]), do: last(tail)

  def tail([]), do: nil
  def tail([_ | tail]), do: tail

  def list_ref([], _), do: nil
  def list_ref([h | _], 0), do: h
  def list_ref([_ | tail], n) do
     list_ref(tail, n - 1)
  end

  def remove_ocurrances(list, element)
  def remove_ocurrances([], _), do: []
  def remove_ocurrances([h | tail], h) do
    remove_ocurrances(tail, h)
  end
  def remove_ocurrances([h | tail], x) do
    [h | remove_ocurrances(tail, x)]
  end

  def foldl(op, acc, list)
  def foldl(_, acc, []), do: acc
  def foldl(op, acc, [h | tail]) do
    foldl(op, op.(acc, h), tail)
  end

  def foldr(op, acc, list)
  def foldr(_, acc, []), do: acc
  def foldr(op, acc, [h | tail]) do
    op.(h, foldr(op, acc, tail))
  end

  def wrap(term)
  def wrap(list) when is_list(list) do
    list
  end
  def wrap(nil) do
    []
  end
  def wrap(other) do
    [other]
  end

  def zip_with(f, lhs, rhs)
  def zip_with(_, [], _) do
    []
  end
  def zip_with(_, _, []) do
    []
  end 
  def zip_with(f, [h1 | tail1], [h2 | tail2]) do
    [ f.(h1, h2) | zip_with(f, tail1, tail2) ]
  end

  def zip(lhs, rhs) do
    zip_with(&{ &1, &2 }, lhs, rhs)
  end

  def map(list, f)
  def map([], _), do: []
  def map([head | tail], f) do
    [f.(head) | map(tail, f) ]
  end

  def filter(list, predicate)
  def filter([], _) do
    []
  end
  def filter([head | tail], predicate) do
    filteredTail = filter(tail, predicate)
    if predicate.(head) do
      [head | filteredTail]
    else
      filteredTail
    end
  end

  def take(n, list)
  def take(_, []) do
    []
  end
  def take(0, _) do
    []
  end
  def take(n, [head | tail]) do
    [head | take(n - 1, tail)]
  end

  def drop(n, list)
  def drop(_, []) do
    []
  end
  def drop(0, list) do
    list
  end
  def drop(n, [_ | tail]) do
   drop(n - 1, tail)
  end
  
  def insert_back(list, x)
  def insert_back([], x) do
    [x]
  end
  def insert_back([h | tail], x) do
    [h | insert_back(tail, x)]
  end

  def concat(lhs, rhs)
  def concat(lhs, []) do
    lhs
  end
  def concat(lhs, [h | tail]) do
    concat(insert_back(lhs, h), tail)
  end

  def accConcat(lhs, rhs) do
    foldl(&insert_back/2, lhs, rhs)
  end 

  def reverse(list)
  def reverse([]) do
    []
  end
  def reverse([h | tail]) do
    insert_back(reverse(tail), h)
  end

  def insert_front(list, x)
  def insert_front([], x) do
    [x]
  end
  def insert_front([h | tail], x) do
    [x, h | tail]
  end

  def accReverse(list) do
    foldl(&insert_front/2, [], list)
  end
  
  def product(list) do
    foldl(&(&1 * &2), 1, list)
  end

  def sum(list) do
    foldl(&(&1 + &2), 0, list)
  end

  def count_if(list, pred) when is_list(list) do
    list |> map(&(if pred.(&1) do 1 else 0 end))
         |> sum()
  end

  def length(list) when is_list(list) do
    count_if(list, (fn _ -> true end))
  end

  def member(list, x)
  def member([], _), do: false
  def member([x | _], x), do: true
  def member([_ | tail], x) do
    member(tail, x)
  end

  def unique(list)
  def unique([]) do
    []
  end
  def unique([h | tail]) do
    if member(tail, h) do
      unique(tail)
    else
      [h | unique(tail)]
    end
  end

  def enumFromTo(from, to)
  def enumFromTo(from, to) when from > to do 
    []
  end
  def enumFromTo(from, to) do
    [from | enumFromTo(from + 1, to)]
  end

  def replicate(value, times) do
    enumFromTo(1, times) |> map(fn _ -> value end)
  end

  def flatten(list)
  def flatten([]) do
    []
  end
  def flatten([h | tail]) when not(is_list(h)) do
    [h | flatten(tail)]
  end
  def flatten([h | tail]) do
    flatten(h) ++ flatten(tail)
  end

  def sort([]) do
    []
  end
  def sort([h | tail]) do
    sortedLeft = tail |> filter(&(&1 <= h))
    sortedRight = tail |> filter(&(&1 > h))
    sortedLeft ++ [h | sortedRight]
  end

  def all_of(list, predicate) do
    count_if(list, predicate) == MyList.length(list)
  end

  def inverse(predicate) do
    &(not(predicate.(&1)))
  end

  def any_of(list, predicate) do
    not(all_of(list, inverse(predicate)))
  end

end