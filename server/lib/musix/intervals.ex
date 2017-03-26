defmodule Musix.Intervals do
  # thanks to https://en.wikipedia.org/wiki/Interval_(music)
  @intervals %{
    "P1" => %{"semitones" => 0,
              "name" => "Perfect unison",
              "alt" => "",
              "alt_short" => ""},
    "d2" => %{"semitones" => 0,
              "name" => "Diminished second",
              "alt" => "",
              "alt_short" => ""},
    "m2" => %{"semitones" => 1,
              "name" => "Minor second",
              "alt" => ["Semitone","half tone", "half step"],
              "alt_short" => "S"},
    "A1" => %{"semitones" => 1,
              "name" => "Augmented unison",
              "alt" => ["Semitone","half tone", "half step"],
              "alt_short" => "S"},
    "M2" => %{"semitones" => 2,
              "name" => "Major second",
              "alt" => ["Tone","whole tone", "whole step"],
              "alt_short" => "T"},
    "d3" => %{"semitones" => 2,
              "name" => "Diminished third",
              "alt" => ["Tone","whole tone", "whole step"],
              "alt_short" => "T"},
    "m3" => %{"semitones" => 3,
              "name" => "Minor third",
              "alt" => "",
              "alt-short" => ""},
    "A2" => %{"semitones" => 3,
              "name" => "Augmented second",
              "alt" => "",
              "alt-short" => ""},
    "M3" => %{"semitones" => 4,
              "name" => "Minor third",
              "alt" => "",
              "alt-short" => ""},
    "d4" => %{"semitones" => 4,
              "name" => "Diminished fourth",
              "alt" => "",
              "alt-short" => ""},
    "P4" => %{"semitones" => 5,
              "name" => "Perfect fourth",
              "alt" => "",
              "alt-short" => ""},
    "A3" => %{"semitones" => 5,
              "name" => "Augmented third",
              "alt" => "",
              "alt-short" => ""},
    "d5" => %{"semitones" => 6,
              "name" => "Diminished fifth",
              "alt" => "Tritone",
              "alt-short" => "TT"},
    "A4" => %{"semitones" => 6,
              "name" => "Augmented fourth",
              "alt" => "Tritone",
              "alt-short" => "TT"},
    "P5" => %{"semitones" => 7,
              "name" => "Perfect fifth",
              "alt" => "",
              "alt-short" => ""},
    "d6" => %{"semitones" => 7,
              "name" => "Diminished sixth",
              "alt" => "",
              "alt-short" => ""},
    "m6" => %{"semitones" => 8,
              "name" => "Minor sixth",
              "alt" => "",
              "alt-short" => ""},
    "A5" => %{"semitones" => 8,
              "name" => "Augmented fifth",
              "alt" => "",
              "alt-short" => ""},
    "M6" => %{"semitones" => 9,
              "name" => "Major sixth",
              "alt" => "",
              "alt-short" => ""},
    "d7" => %{"semitones" => 9,
              "name" => "Diminished seventh",
              "alt" => "",
              "alt-short" => ""},
    "m7" => %{"semitones" => 10,
              "name" => "Minor seventh",
              "alt" => "",
              "alt-short" => ""},
    "A6" => %{"semitones" => 10,
              "name" => "Augmented sixth",
              "alt" => "",
              "alt-short" => ""},
    "M7" => %{"semitones" => 11,
              "name" => "Major seventh",
              "alt" => "",
              "alt-short" => ""},
    "d8" => %{"semitones" => 11,
              "name" => "Diminished octave",
              "alt" => "",
              "alt-short" => ""},
    "P8" => %{"semitones" => 12,
              "name" => "Perfect octave",
              "alt" => "",
              "alt-short" => ""},
    "A7" => %{"semitones" => 12,
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

    defmacro __using__(_) do
      quote do
        import Musix.Intervals
      end
    end
end
