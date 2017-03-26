defmodule Musix.IntervalsTest do
  use ExUnit.Case
  use Musix.Intervals

  test "can get intervals" do
    case get_intervals() do
      {:ok, intervals} ->
        assert(is_map(intervals))
    end
  end

  test "can get interval" do
    case get_interval("A7") do
      {tag, interval} ->
        assert(tag === :ok)
        assert(is_map(interval))
    end

    case get_interval("D7") do
      {tag, _} ->
        assert(tag === :error)
    end
  end
end
