defmodule Musix.Chord do
  use Musix.Note

  @chords %{"major" => %{"long" => "major triad",
                         "long_desc" => "a root note (the note you gave at first, a major third and a perfect fifth"},
            "minor" => %{"long" => "minor triad",
                         "long_desc" => "a root note (the note you gave at first), a minor third and a perfect fifth"},
            "aug" => %{"long" => "augmented triad",
                       "long_desc" => "a root note (the note you gave at first), a major third and a augmented fifth"},
            "dim" => %{"long" => "diminished triad",
                       "long_desc" => "a root note (the note you gave at first), a minor third and a diminished fifth"},
            "7" => %{"long" => "dominant seventh",
                     "long_desc" => "a major triad with a seventh."}}

  def get_chords do
    @chords
  end

  def get_chords(root) do
    {
      :ok,
    (for {chord_name, v} <-
      @chords, into: %{}, do: {
        chord_name,
        add_chord_to_chords(
          chord_name, get_chord(chord_name, root)
        )})
    }
  end

  def add_chord_to_chords(chord, value) do
    case value do
      {:ok, new} ->
        Map.put(@chords[chord], "chord", new[chord]["chord"])
    end
  end

  def validate_chord(chord) do
    case Map.get(@chords, chord) do
      nil ->
        {:error, "chord not found"}
      x ->
        {:ok, x}
    end
  end

  def get_chord(chord, root) do
    case chord do
      "major" ->
        get_major_triad(root)
      "minor" ->
        get_minor_triad(root)
      "aug" ->
        get_augmented_triad(root)
      "dim" ->
        get_diminished_triad(root)
      "7" ->
        get_dominant_seventh(root)
      _ ->
        {:error, "Unknown chord"}
    end
  end

  ## a major triad is composed by a root note, a major third and a perfect fifth
  def get_major_triad(root) do
    case get_major_third(root) do
      {:ok, third} ->
        case get_perfect_fifth(root) do
          {:ok, fifth} ->
            {
              :ok,
              %{"major" => Map.merge(@chords["major"],
                %{
                  "chord" => [root, third, fifth]
                })}
            }
          {:error, message} ->
            {
              :error,
              "Error while obtaining the fifth : " <> message
            }
        end
      {:error, message} ->
        {
          :error,
          "Error while obtaining the fifth : " <> message
        }
    end
  end

  ## a minor triad is composed by a root note, a minor third and a perfect fifth
  def get_minor_triad(root) do
    case get_minor_third(root) do
      {:ok, third} ->
        case get_perfect_fifth(root) do
          {:ok, fifth} ->
            {
              :ok,
              %{"minor" => Map.merge(@chords["minor"],
                %{
                  "chord" => [root, third, fifth]
                })}
            }
          {:error, message} ->
            {
              :error,
              "Error while obtaining the fifth : " <> message
            }
        end
      {:error, message} ->
        {
          :error,
          "Error while obtaining the fifth : " <> message
        }
    end
  end

  ## an augmented triad is composed by a root note, a major third and an augmented fifth
  def get_augmented_triad(root) do
    case get_major_third(root) do
      {:ok, third} ->
        case get_augmented_fifth(root) do
          {:ok, fifth} ->
            {
              :ok,
              %{"aug" => Map.merge(@chords["aug"],
                %{
                  "chord" => [root, third, fifth]
                })}
            }
          {:error, message} ->
            {
              :error,
              "Error while obtaining the fifth : " <> message
            }
        end
      {:error, message} ->
        {
          :error,
          "Error while obtaining the fifth : " <> message
        }
    end
  end

  ## a diminished triad is composed by a root note, a major third and a diminished fifth
  def get_diminished_triad(root) do
    case get_minor_third(root) do
      {:ok, third} ->
        case get_diminished_fifth(root) do
          {:ok, fifth} ->
            {
              :ok,
              %{"dim" => Map.merge(@chords["dim"],
                %{
                  "chord" => [root, third, fifth]
                })}
            }
          {:error, message} ->
            {
              :error,
              "Error while obtaining the fifth : " <> message
            }
        end
      {:error, message} ->
        {
          :error,
          "Error while obtaining the fifth : " <> message
        }
    end
  end

  ## a dominant seventh chord is composed by a root note, a major third, a perfect fifth and a seventh
  def get_dominant_seventh(root) do
    case get_major_triad(root) do
      {:ok, chord} ->
        case get_minor_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"7" => Map.merge(@chords["aug"],
                %{
                  "chord" => chord["major"]["chord"] ++ [seventh]
                })}
            }
        end
      {:error, message} ->
        {
          :error,
          "Error while obtaning the major triad : " <> message
        }
    end
  end

  defmacro __using__(_) do
    quote do
      import Musix.Chord
    end
  end
end


%{
  "7" =>
  %{
    "chord" => ["Ab", "C", "Ds" | "Fs"],
    "long" => "dominant seventh",
    "long_desc" => "a major triad with a seventh."
  },
  "aug" =>
    %{
      "chord" => ["Ab", "C", "E"],
      "long" => "augmented triad",
      "long_desc" => "a root note (the note you gave at first), a major third and a augmented fifth"
    },
  "dim" =>
    %{
      "chord" => ["Ab", "B", "D"],
      "long" => "diminished triad",
      "long_desc" => "a root note (the note you gave at first), a minor third and a diminished fifth"
    },
  "major" =>
    %{
      "chord" => ["Ab", "C", "Ds"],
      "long" => "major triad",
      "long_desc" => "a root note (the note you gave at first, a major third and a perfect fifth"
    },
  "minor" =>
    %{
      "chord" => ["Ab", "B", "Ds"],
      "long" => "minor triad",
      "long_desc" => "a root note (the note you gave at first), a minor third and a perfect fifth"
    }
}
