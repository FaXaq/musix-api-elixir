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

  def validate_chord(chord) do
    case Map.get(@chords, chord) do
      nil ->
        {:error, "chord not found"}
      x ->
        {:ok, x}
    end
  end

  def get_chord(chord, note) do
    case chord do
      "major" ->
        get_major_triad(note)
      "minor" ->
        get_minor_triad(note)
      "aug" ->
        get_augmented_triad(note)
      "dim" ->
        get_diminished_triad(note)
      "7" ->
        get_dominant_seventh(note)
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
              %{"major" => @chords["major"]},
              [root, third, fifth]
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
              %{"minor" => @chords["minor"]},
              [root, third, fifth]
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
              %{"aug" => @chords["aug"]},
              [root, third, fifth]
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
              %{"dim" => @chords["dim"]},
              [root, third, fifth]
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
      {:ok, _, chord} ->
        case get_minor_seventh(root) do
          {:ok, seventh} ->
            {
              :ok,
              %{"7" => @chords["7"]},
              chord ++ [seventh]
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
