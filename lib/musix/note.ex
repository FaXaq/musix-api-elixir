defmodule Musix.Note do
  @moduledoc """
  """

  # constants
  @notes {"Ab","A","As","Bb","B","C","Cs","Db","D","Ds","Eb","E","F","Fs","Gb","G","Gs"}
  @notes_length length Tuple.to_list @notes

  def get_notes do
    Tuple.to_list @notes
  end

  def get_note_index(note) do
    valid_notes = Tuple.to_list @notes
    case Enum.find_index(valid_notes, fn(x) -> x == note end) do
      nil ->
        {:error, "Wrong note"}
      index ->
        {:ok, index}
    end
  end

  def get_flattened_note(note) do
    # since there is two description of a note sometimes (sharp or flat), ensure
    # interval is well done
    interval =
      case String.contains?(note, "b") do
        true ->
          2
        _ ->
          1
      end

    case get_note_index(note, :desc) do
      #when note_index is superior to 0, give previous element in tuple
      {:ok, index} when index > 0 ->
        {:ok, elem(@notes, index-interval)}

        #else give last one
      {:ok, _} ->
        {:ok, elem(@notes,@notes_length-interval)}
      _ ->
        {:error, "Couldn't get the flattened note from " <> note}
    end
  end

  #a sharpened note is a semi-tone above the note given in parameter
  def get_sharpened_note(note) do
    # since there is two description of a note sometimes (sharp or flat), ensure
    # interval is well done
    interval =
      case String.contains?(note, "s") do
        true ->
          2
        _ ->
          1
      end

    case get_note_index(note, :asc) do
        #when note_index is last, give first one
      {:ok, index} when index === @notes_length-1 ->
        {:ok, elem(@notes,1)}

        #else give next note
      {:ok, index} when is_integer(index) ->
        {:ok, elem(@notes,index+interval)}

      _ ->
        {:error, "Couldn't get the sharpened note from " <> note}
    end
  end

  def get_note_index(note, order) do
    case order do
      :asc ->
        notes = Tuple.to_list @notes
        {:ok, Enum.find_index(notes, fn(x) -> x == note end)}
      :desc ->
        notes = Tuple.to_list @notes
        {:ok, Enum.find_index(notes, fn(x) -> x == note end)}
    end
  end

  ## a perfect fifth is 7 semi-tones above root note
  def get_perfect_fifth(root) do
    case get_note_above(root, 7) do
      {:ok, note} ->
        {:ok, note}
      {:error, message} ->
        {:error, message}
    end
  end

  ## a major third is 4 semi-tones above root note
  def get_major_third(root) do
    case get_note_above(root, 4) do
      {:ok, note} ->
        {:ok, note}
      {:error, message} ->
        {:error, message}
    end
  end

  ##functions to get note above from root and semi-tones intervals
  def get_note_above(root, interval) when interval > 0 do
    case get_sharpened_note(root) do
      {:ok, note} ->
        get_note_above(note, interval-1)
      {:error, message} ->
        {:error, message}
    end
  end

  def get_note_above(root, interval) when interval == 0 do
    {:ok, root}
  end

  defmacro __using__(_) do
    quote do
      import Musix.Note
    end
  end
end
