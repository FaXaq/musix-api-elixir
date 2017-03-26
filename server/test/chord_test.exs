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
    case get_major_triad_c("C") do
      {atom, chord} ->
        assert(["C","E","G"] === chord["major"]["chord"])
        assert(atom == :ok)
    end
  end

  test "get a minor triad" do
    case get_minor_triad_c("C") do
      {atom, chord} ->
        assert(["C","Ds","G"] === chord["minor"]["chord"])
        assert(atom == :ok)
    end
  end

  test "get an augmented triad" do
    case get_augmented_triad_c("G") do
      {atom, chord} ->
        assert(["G","B","Ds"] === chord["aug"]["chord"])
        assert(atom == :ok)
    end
  end

  test "get a diminished triad" do
    case get_diminished_triad_c("G") do
      {atom, chord} ->
        assert(["G","As","Cs"] === chord["dim"]["chord"])
        assert(atom == :ok)
    end
  end

  test "get a dominant seventh" do
    case get_dominant_seventh_c("Ab") do
      {atom, chord} ->
        assert(["Ab","C","Eb","Gb"] === chord["7"]["chord"])
        assert(atom == :ok)
    end
  end
end
