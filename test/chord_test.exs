defmodule Musix.ChordTest do
  use ExUnit.Case
  use Musix.Chord

  test "get all chords" do
    case get_chords() do
      x ->
        assert(is_map(x))
    end
  end

  test "get a major triad" do
    case get_major_triad("C") do
      {atom, chord} ->
        assert(["C","E","G"] === chord)
        assert(atom == :ok)
    end
  end

  test "get a minor triad" do
    case get_minor_triad("C") do
      {atom, chord} ->
        assert(["C","Eb","G"] === chord)
        assert(atom == :ok)
    end
  end

  test "get an augmented triad" do
    case get_augmented_triad("G") do
      {atom, chord} ->
        assert(["G","B","Ds"] === chord)
        assert(atom == :ok)
    end
  end

  test "get a diminished triad" do
    case get_diminished_triad("G") do
      {atom, chord} ->
        assert(["G","Bb","Db"] === chord)
        assert(atom == :ok)
    end
  end

  test "get a dominant seventh" do
    case get_dominant_seventh("Ab") do
      {atom, chord} ->
        assert(["Ab","C","Ds","Fs"] === chord)
        assert(atom == :ok)
    end
  end
end
