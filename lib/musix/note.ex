defmodule Musix.Note do
  @moduledoc """
  """

  # constants
  @notes {"Ab","A","As","Bb","B","Bs","Cb","C","Cs","Db","D","Ds","Eb","E","Es","Fb","F","Fs","Gb","G","Gs"}
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

  # flatten note given in parameter
  def flatten_note(note) do
    case get_note_index(note) do
      {:ok, _} ->
        #to flatten note append b at the end
        case String.contains?(note, "s") or String.contains?(note, "bb") do
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
          case String.contains?(note, "C") or String.contains?(note, "F") do
            true ->
              3
            false ->
              2
          end
        _ ->
          1
      end

    case get_note_index(note) do
      #when note_index is superior to 0, give previous element in tuple
      {:ok, index} when index > 0 ->
        {:ok, elem(@notes, index-interval)}

      #else give last one
      {:ok, _} ->
        {:ok, elem(@notes,@notes_length-interval)}
      _ ->
        case get_note_alias(note) do
          x when x === note ->
            {:error, "Couldn't get the sharpened note from " <> note}
          x ->
            get_flattened_note(x)
        end
    end
  end

  def sharpen_note(note) do
    case get_note_index(note) do
      {:ok, _} ->
        #to flatten note append b at the end
        case String.contains?(note, "b") or String.contains?(note, "ss") do
          true ->
            get_sharpened_note(note)
          false ->
            {:ok, note <> "s"}
        end
      {:error, _} ->
        case get_note_alias(note) do
          x when x === note ->
            {:error, "Please enter a valid note" <> note}
          x ->
            sharpen_note(x)
        end
    end
  end

  #a sharpened note is a semi-tone above the note given in parameter
  def get_sharpened_note(note) do
    # since there is two description of a note sometimes (sharp or flat), ensure
    # interval is well done
    interval =
      case String.contains?(note, "s") do
        true ->
          case String.contains?(note, "B") or String.contains?(note, "E") do
            true ->
              3
            false ->
              2
          end
        _ ->
          1
      end

    case get_note_index(note) do
        #when note_index is last, give first one
      {:ok, index} when index === @notes_length-1 ->
        {:ok, elem(@notes,1)}

        #else give next note
      {:ok, index} when is_integer(index) ->
        {:ok, elem(@notes,index+interval)}

      _ ->
        case get_note_alias(note) do
          x when x === note->
            {:error, "Couldn't get the sharpened note from " <> note}
          x ->
            get_sharpened_note(x)
        end
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
  def get_note_alias_if_needed(root, note, semitones) do
    # Check if :
    # - note should be flat (because of semitones relative to parent note are negatives)
    # - note should be sharp (because of semitones relative to parent note are positives)
    # - if there is a missmatch between the alteration (flat or sharp) of root and note
    case (semitones < 0 and is_sharp?(note) or
      semitones > 0 and is_flat?(note) or
      (are_missmatch_altered?(root, note))) do
      true ->
        get_note_alias(note)
      false ->
        # check if only note is altered
        case (!is_altered?(root) and is_altered?(note)) do
          true ->
            # if so check if note alias is not
            case get_note_alias(note) do
              note_alias ->
                case is_altered?(note_alias) do
                  true ->
                    note
                  false ->
                    # if not retur note alias
                    note_alias
                end
            end
          false ->
            note
        end
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

  defp is_altered?(note) do
    is_flat?(note) or is_sharp?(note)
  end

  defp is_flat?(note) do
    String.contains?(note, "b")
  end

  defp is_sharp?(note) do
    String.contains?(note, "s")
  end

  defp are_missmatch_altered?(root, note) do
    (is_flat?(root) and is_sharp?(note)) or
    (is_sharp?(root) and is_flat?(note))
  end

  defp are_both_altered?(root, note) do
    is_altered?(root) and is_altered?(note)
  end

  defp are_none_altered?(root, note) do
    is_altered?(root) or is_altered?(note)
  end

  defp get_note_alteration(note) do
    case is_flat?(note) do
      true ->
        :flat
      false ->
        case is_sharp?(note) do
          true ->
            :sharp
          false ->
            :natural
        end
    end
  end

  defmacro __using__(_) do
    quote do
      import Musix.Note
    end
  end
end
