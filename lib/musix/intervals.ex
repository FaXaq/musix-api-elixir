defmodule Musix.Intervals do
  use Musix.Note

  # thanks to https://en.wikipedia.org/wiki/Interval_(music)
  @intervals %{
    "P1" => %{"semitones" => 0,
              "name" => "Perfect unison",
              "alt" => "",
              "alt_short" => ""},
    "d2" => %{"parent" => "M2",
              "semitones" => -2,
              "name" => "Diminished second",
              "alt" => "",
              "alt_short" => ""},
    "m2" => %{"parent" => "M2",
              "semitones" => -1,
              "name" => "Minor second",
              "alt" => ["Semitone","half tone", "half step"],
              "alt_short" => "S"},
    "A1" => %{"parent" => "P1",
              "semitones" => 1,
              "name" => "Augmented unison",
              "alt" => ["Semitone","half tone", "half step"],
              "alt_short" => "S"},
    "M2" => %{"parent" => "P1",
              "semitones" => 2,
              "name" => "Major second",
              "alt" => ["Tone","whole tone", "whole step"],
              "alt_short" => "T"},
    "d3" => %{"parent" => "M3",
              "semitones" => -2,
              "name" => "Diminished third",
              "alt" => ["Tone","whole tone", "whole step"],
              "alt_short" => "T"},
    "m3" => %{"parent" => "M3",
              "semitones" => -1,
              "name" => "Minor third",
              "alt" => "",
              "alt-short" => ""},
    "A2" => %{"parent" => "M2",
              "semitones" => 1,
              "name" => "Augmented second",
              "alt" => "",
              "alt-short" => ""},
    "M3" => %{"parent" => "P1",
              "semitones" => 4,
              "name" => "Minor third",
              "alt" => "",
              "alt-short" => ""},
    "d4" => %{"parent" => "P4",
              "semitones" => -1,
              "name" => "Diminished fourth",
              "alt" => "",
              "alt-short" => ""},
    "P4" => %{"parent" => "P1",
              "semitones" => 5,
              "name" => "Perfect fourth",
              "alt" => "",
              "alt-short" => ""},
    "A3" => %{"parent" => "M3",
              "semitones" => 1,
              "name" => "Augmented third",
              "alt" => "",
              "alt-short" => ""},
    "d5" => %{"parent" => "P5",
              "semitones" => -1,
              "name" => "Diminished fifth",
              "alt" => "Tritone",
              "alt-short" => "TT"},
    "A4" => %{"parent" => "P4",
              "semitones" => 1,
              "name" => "Augmented fourth",
              "alt" => "Tritone",
              "alt-short" => "TT"},
    "P5" => %{"parent" => "P1",
              "semitones" => 7,
              "name" => "Perfect fifth",
              "alt" => "",
              "alt-short" => ""},
    "d6" => %{"parent" => "M6",
              "semitones" => -2,
              "name" => "Diminished sixth",
              "alt" => "",
              "alt-short" => ""},
    "m6" => %{"parent" => "M6",
              "semitones" => -1,
              "name" => "Minor sixth",
              "alt" => "",
              "alt-short" => ""},
    "A5" => %{"parent" => "P5",
              "semitones" => 1,
              "name" => "Augmented fifth",
              "alt" => "",
              "alt-short" => ""},
    "M6" => %{"parent" => "P1",
              "semitones" => 9,
              "name" => "Major sixth",
              "alt" => "",
              "alt-short" => ""},
    "d7" => %{"parent" => "M7",
              "semitones" => -2,
              "name" => "Diminished seventh",
              "alt" => "",
              "alt-short" => ""},
    "m7" => %{"parent" => "M7",
              "semitones" => -1,
              "name" => "Minor seventh",
              "alt" => "",
              "alt-short" => ""},
    "A6" => %{"parent" => "M6",
              "semitones" => 1,
              "name" => "Augmented sixth",
              "alt" => "",
              "alt-short" => ""},
    "M7" => %{"parent" => "P1",
              "semitones" => 11,
              "name" => "Major seventh",
              "alt" => "",
              "alt-short" => ""},
    "d8" => %{"parent" => "P8",
              "semitones" => -1,
              "name" => "Diminished octave",
              "alt" => "",
              "alt-short" => ""},
    "P8" => %{"parent" => "P1",
              "semitones" => 12,
              "name" => "Perfect octave",
              "alt" => "",
              "alt-short" => ""},
    "A7" => %{"parent" => "M7",
              "semitones" => 12,
              "name" => "Augmented seventh",
              "alt" => "",
              "alt-short" => ""}
  }

  def get_intervals do
    {:ok, @intervals}
  end

  def get_interval(name) do
    case Map.has_key?(@intervals, name) do
      true ->
        {:ok, @intervals[name]}
      false ->
        {:error, "Cannot find interval : " <> name}
    end
  end

  def get_interval_semitones(name) do
    case get_interval(name) do
      {:ok, interval} ->
        case Map.has_key?(interval, "semitones") do
          true ->
            {:ok, interval["semitones"]}
          false ->
            {:error, "Cannot find semitones for interval : " <> name}
        end
      {:error, message} ->
        {:error, message}
    end
  end

  #retrieve interval from parent
  def get_parent_interval_semitones(interval) do
    case Map.has_key?(interval, "parent") do
      true ->
        get_interval_semitones(interval["parent"])
      false ->
        {:ok, 0}
    end
  end

  #get parent note, before altering it
  def get_parent_note(root, interval_name) do
    #retrieve interval
    case get_interval(interval_name) do
      {:ok, interval} ->
        # getparent interval semitones
        case get_parent_interval_semitones(interval) do
          {:ok, semitones} when semitones > 0 ->
            #get note above
            case get_note_above(root, semitones) do
              {:ok, note} ->
                {:ok, note}
              {:error, message} ->
                {:error, message}
            end
          {:ok, semitones} when semitones == 0 ->
            {:ok, root}
          {:error, message} ->
            {:error, message}
        end
      {:error, message} ->
        {:error, message}
    end
  end

  ## get note from interval and root
  def get_note(root, interval) do
    case get_parent_note(root, interval) do
      {:ok, note} ->
        case get_interval_semitones(interval) do
          {:ok, semitones} ->
            # retrieve note alias if needed
            case get_note_by_semitones(note, semitones) do
              {:ok, note} ->
                {:ok, get_note_alias_if_needed(root, note)}
              {:error, message} ->
                {:error, message}
            end
          {:error, message} ->
            {:error, message}
        end
      {:error, message} ->
        {:error, message}
    end
  end

  def get_note_by_semitones(root, semitones) do
    case semitones > 0 do
      true ->
        get_altered_note_above(root, semitones)
      false ->
        get_altered_note_below(root, semitones)
    end
  end

  ##########
  ## misc ##
  ##########

  ## get semi-tones between notes
  def get_semi_tones_between(root, note) do
    case root === note do
      true ->
        0
      false ->
        get_semi_tones_between(root, note, 0)
    end
  end

  ## get semi-tones between notes
  def get_semi_tones_between(root, note, interval) do
    case get_sharpened_note(root) do
      {:ok, new_root} ->
        case compare_notes(new_root, note) do
          true ->
            interval + 1
          false ->
            get_semi_tones_between(new_root, note, interval + 1)
        end
    end
  end

  ## get semi-tones between notes
  def get_tones_between(root, note) do
    get_semi_tones_between(root,note) / 2
  end

  defmacro __using__(_) do
    quote do
      import Musix.Intervals
    end
  end
end
