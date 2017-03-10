defmodule Musix.Chord do
  use Musix.Note

  @chords %{"major" => "major","minor" => "minor","augmented" => "aug","diminished" => "dim"}

  def get_chords do
    @chords
  end

  ## a major triad is composed by a root note, a major third and a perfect fifth
  def get_major_triad(root) do
    case get_major_third(root) do
      {:ok, third} ->
        case get_perfect_fifth(root) do
          {:ok, fifth} ->
            {
              :ok,
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

  defmacro __using__(_) do
    quote do
      import Musix.Chord
    end
  end
end
