defmodule Musix.Chord do
  use Musix.Note

  ## a major triad is composed by a root note, a major third and a perfect fifth
  def get_major_triad(root) do
    case get_major_third(root) do
      {:ok, third} ->
        case get_perfect_fifth(root) do
          {:ok, fifth} ->
            {:ok, [root, third, fifth]}
          {:error, message} ->
            {:error, "Error while obtaining the fifth : " <> message}
        end
      {:error, message} ->
        {:error, "Error while obtaining the fifth : " <> message}
    end
  end

  defmacro __using__(_) do
    quote do
      import Musix.Chord
    end
  end
end
