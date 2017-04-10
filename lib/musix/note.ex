defmodule Musix.Note do
  @moduledoc """
  """

  # constants
  @notes {"Ab","A","As","Bb","B","C","Cs","Db","D","Ds","Eb","E","F","Fs","Gb","G","Gs"}
  @notes_alias %{"Ab" => "Gs", "Bb" => "As", "Db" => "Cs", "Eb" => "Ds", "Gb" => "Fs",
                 "Gs" => "Ab", "As" => "Bb", "Cs" => "Db", "Ds" => "Eb", "Fs" => "Gb",
                 "Cb" => "B", "Bs" => "C", "Fb" => "E", "Es" => "F",
                 "B" => "Cb", "C" => "Bb", "E" => "Fb", "F" => "Es",
                 "Abb" => "G", "Bbb" => "A", "Cbb" => "Bb", "Dbb" => "C", "Ebb" => "D", "Fbb" => "Eb", "Gbb" => "F",
                 "Gss" => "A", "Ass" => "B", "Bss" => "Cs", "Css" => "D", "Dss" => "E", "Ess" => "Fs", "Fss" => "G"}
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

  # flatten note given in parameter
  def flatten_note(note) do
    case get_note_index(note, :desc) do
      {:ok, _} ->
        #to flatten note append b at the end
        case String.contains?(note, "s") do
          true ->
            get_flattened_note(note)
          false ->
            {:ok, note <> "b"}
        end
      {:error, _} ->
        case get_note_alias(note) do
          x when x === note ->
            {:error, "Please enter a valid note" <> note}
          x ->
            flatten_note(x)
        end
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

  def sharpen_note(note) do
    case get_note_index(note, :desc) do
      {:ok, _} ->
        #to flatten note append b at the end
        case String.contains?(note, "b") do
          true ->
            get_sharpened_note(note)
          false ->
            case String.contains?(note, "ss") do
              true ->
                sharpen_note(get_note_alias(note))
              false ->
                {:ok, note <> "s"}
            end
        end
      {:error, _} ->
        {:error, "Couldn't sharpen the note " <> note}
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

  ## return true if notes are the same
  def compare_notes(note1, note2) do
    case note1 === note2 || get_note_alias(note1) === note2 do
      true ->
        true
      false ->
        false
    end
  end

  ## flip note if needed
  def get_note_alias_if_needed(root, note) do
    case (String.contains?(root,"b") and String.contains?(note, "s")) or
      (String.contains?(root,"s") and String.contains?(note, "b")) do
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
  def get_note_above(root, semitone) when semitone > 0 do
    case get_sharpened_note(root) do
      {:ok, note} ->
        get_note_above(note, semitone-1)
      {:error, message} ->
        {:error, message}
    end
  end

  def get_note_above(root, semitone) when semitone == 0 do
    {:ok, root}
  end

  # altered note
  def get_altered_note_above(root, semitone) when semitone > 0 do
     case sharpen_note(root) do
      {:ok, note} ->
        get_note_above(note, semitone-1)
      {:error, message} ->
        {:error, message}
    end
  end

  # altered note
  def get_altered_note_above(root, semitone) when semitone == 0 do
    {:ok, root}
  end

  ##functions to get note below from root and semi-tones intervals
  def get_note_below(root, semitone) when semitone < 0 do
    case get_flattened_note(root) do
      {:ok, note} ->
        get_note_below(note, semitone+1)
      {:error, message} ->
        {:error, message}
    end
  end

  def get_note_below(root, semitone) when semitone == 0 do
    {:ok, root}
  end

  ##functions to get note below from root and semi-tones intervals
  def get_altered_note_below(root, semitone) when semitone < 0 do
    case flatten_note(root) do
      {:ok, note} ->
        get_note_below(note, semitone+1)
      {:error, message} ->
        {:error, message}
    end
  end

  def get_altered_note_below(root, semitone) when semitone == 0 do
    {:ok, root}
  end

  defmacro __using__(_) do
    quote do
      import Musix.Note
    end
  end
end
