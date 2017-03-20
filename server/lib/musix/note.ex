defmodule Musix.Note do
  @moduledoc """
  """

  # constants
  @notes {"Ab","A","As","Bb","B","C","Cs","Db","D","Ds","Eb","E","F","Fs","Gb","G","Gs"}
  @notes_alias %{"Ab" => "Gs", "Bb" => "As", "Db" => "Cs", "Eb" => "Ds", "Gb" => "Fs",
                 "Gs" => "Ab", "As" => "Bb", "Cs" => "Db", "Ds" => "Eb", "Fs" => "Gb"}
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

  #######
  ## 5 ##
  #######

  ## a perfect fifth is 7 semi-tones above root note
  def get_perfect_fifth(root) do
    case get_note_above(root, 7) do
      {:ok, note} ->
        {:ok, get_note_alias_if_needed(root, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  ## a augmented fifth is 8 semi-tones above root note
  def get_augmented_fifth(root) do
    case get_note_above(root, 8) do
      {:ok, note} ->
        {:ok, get_note_alias_if_needed(root, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  ## a diminished fifth is 6 semi-tones above root note
  def get_diminished_fifth(root) do
    note =
      case get_note_above(root, 6) do
        {:ok, note} ->
          {:ok, get_note_alias_if_needed(root, note)}
        {:error, message} ->
          {:error, message}
      end
  end

  #######
  ## 3 ##
  #######

  ## a major third is 4 semi-tones above root note
  def get_major_third(root) do
    case get_note_above(root, 4) do
      {:ok, note} ->
        {:ok, get_note_alias_if_needed(root, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  ## a minor third is 3 semi-tones above root note
  def get_minor_third(root) do
    case get_note_above(root, 3) do
      {:ok, note} ->
        {:ok, get_note_alias_if_needed(root, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  #######
  ## 7 ##
  #######

  ## a minor seventh is 10 semi-tones above root note
  def get_minor_seventh(root) do
    case get_note_above(root, 10) do
      {:ok, note} ->
        {:ok, get_note_alias_if_needed(root, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  ## a minor seventh is 10 semi-tones above root note
  def get_major_seventh(root) do
    case get_note_above(root, 11) do
      {:ok, note} ->
        {:ok, get_note_alias_if_needed(root, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  ## a minor seventh is 10 semi-tones above root note
  def get_diminished_seventh(root) do
    case get_note_above(root, 9) do
      {:ok, note} ->
        {:ok, get_note_alias_if_needed(root, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  ##########
  ## misc ##
  ##########

  ## flip note if needed
  def get_note_alias_if_needed(root, note) do
    case (String.contains?(root,"b") and String.contains?(note, "s")) or
      (String.contains?(root,"s") and String.contains?(note, "b"))do
      true ->
        get_note_alias(note)
      false ->
        note
    end
  end

  ## sometimes in minor chords essentially, we need alias for flat notes instead of sharp ones
  ## (Bb instead of As for instance)
  def get_note_alias(note) do
    case Map.fetch(@notes_alias, note) do
      {:ok, new_note} ->
        new_note
      _ ->
        note
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
