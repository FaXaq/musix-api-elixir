defmodule Musix.Chord do
  use Musix.Note

  @chords %{
    "major" => %{"long" => "major triad",
                 "long_desc" => "a root note (the note you gave at first, a major third and a perfect fifth"},
    "minor" => %{"long" => "minor triad",
                 "long_desc" => "a root note (the note you gave at first), a minor third and a perfect fifth"},
    "aug" => %{"long" => "augmented triad",
               "long_desc" => "a root note (the note you gave at first), a major third and a augmented fifth"},
    "dim" => %{"long" => "diminished triad",
               "long_desc" => "a root note (the note you gave at first), a minor third and a diminished fifth"},
    "7" => %{"long" => "dominant seventh",
             "long_desc" => "a major triad with a minor seventh."},
    "M7" => %{"long" => "major seventh",
              "long_desc" => "a major triad with a major seventh."},
    "m7" => %{"long" => "minor seventh",
              "long_desc" => "a minor triad with a minor seventh."},
    "hdim7" => %{"long" => "half-diminished seventh",
                 "long_desc" => "a diminished triad with a minor seventh."},
    "dim7" => %{"long" => "diminished seventh",
                "long_desc" => "a diminished triad with a diminished seventh."},
    "mM7" => %{"long" => "minor-major seventh",
               "long_desc" => "a minor triad with a major seventh."},
    "augM7" => %{"long" => "augmented major seventh",
                 "long_desc" => "an augmented triad with a major seventh."},
    "aug7" => %{"long" => "augmented seventh",
                "long_desc" => "an augmented triad with a minor seventh."}
  }

  def get_chords do
    @chords
  end

  def get_chords(root) do
    {
      :ok,
    (for {chord_name, _} <-
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
      {:error, message} ->
        IO.puts(message)
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
        get_major_triad_c(root)
      "minor" ->
        get_minor_triad_c(root)
      "aug" ->
        get_augmented_triad_c(root)
      "dim" ->
        get_diminished_triad_c(root)
      "7" ->
        get_dominant_seventh_c(root)
      "M7" ->
        get_major_seventh_c(root)
      "m7" ->
        get_minor_seventh_c(root)
      "hdim7" ->
        get_half_diminished_seventh_c(root)
      "dim7" ->
        get_diminished_seventh_c(root)
      "mM7" ->
        get_minor_major_seventh_c(root)
      "augM7" ->
        get_augmented_major_seventh_c(root)
      "aug7" ->
        get_augmented_seventh_c(root)
      _ ->
        {:error, "Unknown chord"}
    end
  end

  ## a major triad is composed by a root note, a major third and a perfect fifth
  def get_major_triad_c(root) do
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
  def get_minor_triad_c(root) do
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
  def get_augmented_triad_c(root) do
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
  def get_diminished_triad_c(root) do
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
  def get_dominant_seventh_c(root) do
    case get_major_triad_c(root) do
      {:ok, chord} ->
        case get_minor_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"7" => Map.merge(@chords["7"],
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

  ## a major seventh chord is composed by a root note, a major third, a perfect fifth and a seventh
  def get_major_seventh_c(root) do
    case get_major_triad_c(root) do
      {:ok, chord} ->
        case get_major_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"M7" => Map.merge(@chords["M7"],
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

  ## a minor seventh chord is composed by a root note, a major third, a perfect fifth and a seventh
  def get_minor_seventh_c(root) do
    case get_minor_triad_c(root) do
      {:ok, chord} ->
        case get_minor_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"m7" => Map.merge(@chords["m7"],
                %{
                  "chord" => chord["minor"]["chord"] ++ [seventh]
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

  ## a half-diminished seventh chord is composed by a diminished triad with a minor seventh

  def get_half_diminished_seventh_c(root) do
    case get_diminished_triad_c(root) do
      {:ok, chord} ->
        case get_minor_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"hdim7" => Map.merge(@chords["hdim7"],
                %{
                  "chord" => chord["dim"]["chord"] ++ [seventh]
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

  ## a half-diminished seventh chord is composed by a diminished triad with a minor seventh

  def get_diminished_seventh_c(root) do
    case get_diminished_triad_c(root) do
      {:ok, chord} ->
        case get_diminished_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"dim7" => Map.merge(@chords["dim7"],
                %{
                  "chord" => chord["dim"]["chord"] ++ [seventh]
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

  ## a half-diminished seventh chord is composed by a diminished triad with a minor seventh

  def get_minor_major_seventh_c(root) do
    case get_minor_triad_c(root) do
      {:ok, chord} ->
        case get_major_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"mM7" => Map.merge(@chords["mM7"],
                %{
                  "chord" => chord["minor"]["chord"] ++ [seventh]
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


  ## a half-diminished seventh chord is composed by a diminished triad with a minor seventh

  def get_augmented_major_seventh_c(root) do
    case get_augmented_triad_c(root) do
      {:ok, chord} ->
        case get_major_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"augM7" => Map.merge(@chords["augM7"],
                %{
                  "chord" => chord["aug"]["chord"] ++ [seventh]
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

  ## a half-diminished seventh chord is composed by a diminished triad with a minor seventh

  def get_augmented_seventh_c(root) do
    case get_augmented_triad_c(root) do
      {:ok, chord} ->
        case get_minor_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"aug7" => Map.merge(@chords["aug7"],
                %{
                  "chord" => chord["aug"]["chord"] ++ [seventh]
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