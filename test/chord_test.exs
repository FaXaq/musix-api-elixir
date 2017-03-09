defmodule Musix.ChordTest do
  use ExUnit.Case
  use Musix.Chord

  test "get a major triad" do
    case get_major_triad("C") do
      {atom, chord} ->
        assert(["C","E","G"] === chord)
        assert(atom == :ok)
    end
  end
end
