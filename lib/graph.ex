defmodule AdventOfCode.Graph do
  @type vertex :: any()

  @spec dijkstra(vertex(), (vertex() -> [{number(), vertex()}]), (vertex() -> boolean())) :: any()
  def dijkstra(start, neighbour_func, success_func)
      when is_function(neighbour_func, 1) and is_function(success_func, 1) do
    pq = PriorityQueue.new()
    pq = PriorityQueue.put(pq, 0, start)

    # TODO incase of a non keyable vertex, pass uniquenes function as an argument
    distances = %{start => 0}

    find_shortest_path(pq, distances, neighbour_func, success_func)
  end

  defp find_shortest_path(pq, distances, neighbour_func, success_func) do
    case PriorityQueue.pop(pq) do
      {{nil, nil}, _} ->
        {:error, distances}

      {{_, vertex}, pq} ->
        if success_func.(vertex) do
          {:ok, distance(distances, vertex)}
        else
          {pq, distances} = reduce_neighbours(pq, distances, neighbour_func, vertex)
          find_shortest_path(pq, distances, neighbour_func, success_func)
        end
    end
  end

  defp reduce_neighbours(pq, distances, neighbour_func, vertex) do
    Enum.reduce(neighbour_func.(vertex), {pq, distances}, fn {weight, neighbour},
                                                             {pq, distances} ->
      new_distance = distance(distances, vertex) + weight

      if new_distance < distance(distances, neighbour) do
        pq = PriorityQueue.put(pq, new_distance, neighbour)
        distances = Map.put(distances, neighbour, new_distance)
        {pq, distances}
      else
        {pq, distances}
      end
    end)
  end

  defp distance(distances, vertex) do
    Map.get(distances, vertex, :infinity)
  end
end
