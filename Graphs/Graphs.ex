defmodule Graph do
  #the graphs are represented with maps:
  #the keys are vertex ids and the values are 
  #their neighbours' ids
  defstruct id: "", vertices: %{}

  def vertices_to_list(g = %Graph{}) do
    Map.keys g.vertices
  end

  def has_vertices?(g = %Graph{}, vertices) when is_list(vertices) do
    vertices |> Enum.all?(&(has_vertex(g, &1)))
  end

  def has_vertex?(g = %Graph{}, v) do
    Map.has_key? g.vertices, v
  end

  def has_edges?(g = %Graph{}, edges) when is_list(edges) do
    edges |> Enum.all?(fn {u, v} -> has_edge?(g, u, v) end)
  end

  def has_edge?(g = %Graph{}, u, v) do
    if (has_vertex? g, u) do
      v in neighbours(g, u)
    else
      false
    end
  end

  def neighbours(g = %Graph{}, v) do
     Map.get g.vertices, v
  end

  def insert_vertex(g = %Graph{}, v, neighbours \\[]) do
    if (has_vertex? g, v) do
      g
    else
      %Graph{ id: g.id, vertices: Map.put(g.vertices, v, neighbours) }
    end
  end
   
  def insert_edge(g = %Graph{}, u, v) do    
    insert_neighbours = fn to_insert ->
      fn 
        nil        -> {nil, to_insert}
        neighbours -> {neighbours, neighbours ++ to_insert}
      end
    end
    {_, newVertices} = g.vertices |> Map.get_and_update(u, insert_neighbours.([v]))
    {_, finalVertices} = newVertices |> Map.get_and_update(v, insert_neighbours.([]))
    %Graph{ id: g.id, vertices: finalVertices }
  end

  def remove_edge(g = %Graph{}, {u, v}) do
    if [u, v] |> Enum.all?(&(has_vertex?(g, &1))) do
      remove_v = fn 
         neighbours -> {neighbours, neighbours |> List.delete(v)} 
      end
      {_, newVertices} = g.vertices |> Map.get_and_update(u, remove_v)
      %Graph{ id: g.id, vertices: newVertices }
    else
      g
    end
  end

  def remove_vertex(g = %Graph{}, v) do
    g2 = %Graph{ g.id, g.vertices |> Map.delete(v) }
    vertices_to_list(g2) |> 
      List.foldl(g2, fn result, w -> remove_edge(result, w, v) end)
  end
end

