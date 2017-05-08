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

  test "get semi-tones between" do
    case get_semi_tones_between("A","As") do
      x ->
        assert(x === 1)
    end

    case get_semi_tones_between("A","Ab") do
      x ->
        assert(x === 11)
    end
  end

  test "apply interval" do
    case get_note("C", "m7") do
      {atom, note} ->
        assert(atom === :ok)
        assert(note == "Bb")
    end

    case get_note("C", "M7") do
      {atom, note} ->
        assert(atom === :ok)
        assert(note == "B")
    end

    case get_note("C", "P4") do
      {atom, note} ->
        assert(atom === :ok)
        assert(note == "F")
    end
  end

  test "get parent note" do
    case get_parent_note("C", "m7") do
      {atom, note} ->
        assert(atom === :ok)
        assert(note == "B")
    end
  end
end
