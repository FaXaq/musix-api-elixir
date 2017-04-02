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
    case get_chord("major","C") do
      {atom, chord} ->
        assert(atom == :ok)
        assert(["C","E","G"] === chord["notes"])
    end
  end

  test "get a minor triad" do
    case get_chord("minor","C") do
      {atom, chord} ->
        assert(["C","Ds","G"] === chord["notes"])
        assert(atom == :ok)
    end
  end

  test "get an augmented triad" do
    case get_chord("aug","G") do
      {atom, chord} ->
        assert(["G","B","Ds"] === chord["notes"])
        assert(atom == :ok)
    end
  end

  test "get a diminished triad" do
    case get_chord("dim","G") do
      {atom, chord} ->
        assert(["G","As","Cs"] === chord["notes"])
        assert(atom == :ok)
    end
  end

  test "get a dominant seventh" do
    case get_chord("7","Ab") do
      {atom, chord} ->
        assert(["Ab","C","Eb","Gb"] === chord["notes"])
        assert(atom == :ok)
    end
  end
end
