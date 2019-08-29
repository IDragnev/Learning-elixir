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

  def foldl(list, acc, op)
  def foldl([], acc, _) do
    acc
  end
  def foldl([h | tail], acc, op) do
    foldl(tail, op.(acc, h), op)
  end

  def foldr(list, acc, op)
  def foldr([], acc, _) do
    acc
  end
  def foldr([h | tail], acc, op) do
    op.(h, foldr(tail, acc, op))
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

  def take(list, n)
  def take([], _) do
    []
  end
  def take(_, 0) do
    []
  end
  def take([head | tail], n) do
    [head | take(tail, n - 1)]
  end

  def take_while(list, pred) do
    list |> foldr([], fn x, acc -> if pred.(x) do [x | acc] else [] end end)
  end

  def drop(list, n)
  def drop([], _) do
    []
  end
  def drop(list, 0) do
    list
  end
  def drop([_ | tail], n) do
   drop(tail, n - 1)
  end

  def drop_while([], _) do
    []
  end
  def drop_while(list = [h | tail], pred) do
    if pred.(h) do
      drop_while(tail, pred)
    else
      list
    end
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
    lhs |> insert_back(h)
        |> concat(tail)
  end

  def accConcat(lhs, rhs) do
    rhs |> foldl(lhs, &insert_back/2)
  end

  def reverse(list)
  def reverse([]) do
    []
  end
  def reverse([h | tail]) do
    tail |> reverse()
         |> insert_back(h)
  end

  def insert_front(list, x)
  def insert_front([], x) do
    [x]
  end
  def insert_front([h | tail], x) do
    [x, h | tail]
  end

  def accReverse(list) do
    list |> foldl([], &insert_front/2)
  end

  def product(list) do
    list |> foldl(1, &(&1 * &2))
  end

  def sum(list) do
    list |> foldl(0, &(&1 + &2))
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
    sortedLeft  = tail |> filter(&(&1 <= h))
                       |> sort()
    sortedRight = tail |> filter(&(&1 > h))
                       |> sort()
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

  def split(list, index) do
    {take(list, index), drop(list, index)}
  end

  def flip(f) when is_function(f), do: &(f.(&2, &1))

  def scanl(list, acc, fun) do
    f = fn
      acc, current -> acc |> head()
                          |> fun.(current)
                          |> flip(&insert_front/2).(acc)
    end
    list |> foldl([acc], f)
         |> reverse()
         |> tail()
  end

  def min(list, default \\nil)
  def min([], default) do
    default
  end
  def min([h | tail], _) do
    tail |> foldl(h, &Kernel.min/2)
  end

  def max(list, default \\nil)
  def max([], default) do
    default
  end
  def max([h | tail], _) do
    tail |> foldl(h, &Kernel.max/2)
  end

  def chunk(list, chunk_size)
  def chunk([], _) do
    []
  end
  def chunk(list, n) when n > 0 do
    [take(list, n) | (list |> drop(n) |> chunk(n))]
  end

end

