defmodule Musix.Chord do
  use Musix.Note
  use Musix.Intervals

  @chords %{
    "major" => %{"long" => "major triad",
                 "long_desc" => "a major third and a perfect fifth",
                "intervals" => ["P1","M3","P5"]},
    "minor" => %{"long" => "minor triad",
                 "long_desc" => "a minor third and a perfect fifth",
                 "intervals" => ["P1","m3","P5"]},
    "aug" => %{"long" => "augmented triad",
               "long_desc" => "a major third and a augmented fifth",
               "intervals" => ["P1","M3","A5"]},
    "dim" => %{"long" => "diminished triad",
               "long_desc" => "a minor third and a diminished fifth",
               "intervals" => ["P1","m3","d5"]},
    "7" => %{"long" => "dominant seventh",
             "long_desc" => "a major triad with a minor seventh.",
             "intervals" => ["P1","M3","P5","m7"]},
    "M7" => %{"long" => "major seventh",
              "long_desc" => "a major triad with a major seventh.",
              "intervals" => ["P1","M3","P5","M7"]},
    "m7" => %{"long" => "minor seventh",
              "long_desc" => "a minor triad with a minor seventh.",
              "intervals" => ["P1","m3","P5","m7"]},
    "hdim7" => %{"long" => "half-diminished seventh",
                 "long_desc" => "a diminished triad with a minor seventh.",
                 "intervals" => ["P1","m3","d5","m7"]},
    "dim7" => %{"long" => "diminished seventh",
                "long_desc" => "a diminished triad with a diminished seventh",
                "intervals" => ["P1","m3","d5","d7"]},
    "mM7" => %{"long" => "minor-major seventh",
               "long_desc" => "a minor triad with a major seventh.",
                 "intervals" => ["P1","m3","P5","M7"]},
    "augM7" => %{"long" => "augmented major seventh",
                 "long_desc" => "an augmented triad with a major seventh.",
                 "intervals" => ["P1","M3","A5","M7"]},
    "aug7" => %{"long" => "augmented seventh",
                "long_desc" => "an augmented triad with a minor seventh.",
                "intervals" => ["P1","M3","P5","m7"]},
    "sus4" => %{"long" => "suspended four",
                "long_desc" => "",
                "intervals" => ["P1","M3","P4"]}
  }

  # Retrieve all chords definition without notes
  def get_chords do
    @chords
  end

  # Retrieve all chords definitions with notes
  def get_chords(root) do
    {
      :ok,
    (for {chord_name, _} <-
      @chords, into: %{}, do: {
        chord_name,
        add_chord_to_chords(
          chord_name, build_chord(chord_name, root)
        )})
    }
  end

  # Add chord notes to chord definition
  def add_chord_to_chords(chord, value) do
    case value do
      {:ok, new} ->
        Map.put(@chords[chord], "notes", new)
      {:error, message} ->
        {:error, message}
    end
  end

  # Check if chord exists
  def validate_chord(chord) do
    case Map.get(@chords, chord) do
      nil ->
        {:error, "chord not found"}
      x ->
        {:ok, x}
    end
  end

  # Retrieve a single chord definition with notes
  def get_chord(chord, root) do
    case Map.has_key?(@chords, chord) do
      true ->
        case build_chord(chord, root) do
          {:ok, built_chord} ->
            {:ok, add_chord_to_chords(chord, {:ok, built_chord})}
          {:error, message} ->
            {:error, message}
        end
      false ->
        {:error, "Unknown chord : " <> chord}
    end
  end

  # Retrieve chords notes
  def build_chord(chord, root) do
    case get_chord_intervals(chord) do
      {:ok, intervals} ->
        {:ok, Enum.into(intervals, [], fn interval ->
            case get_note(root, interval) do
              {:ok, note} ->
                note
              {:error, message} ->
                message
            end
          end)}
      {:error, message} ->
        {:error, message}
    end
  end

  # Retrieve chords intervals
  def get_chord_intervals(chord) do
    case Map.has_key?(@chords, chord) do
      true ->
        case Map.has_key?(@chords[chord], "intervals") do
          true ->
            {:ok, @chords[chord]["intervals"]}
          false ->
            {:error, "Cannot find intervals for chord : " <> chord}
        end
      false ->
        {:error, "Cannot find chord : " <> chord}
    end
  end

  defmacro __using__(_) do
    quote do
      import Musix.Chord
    end
  end
end
