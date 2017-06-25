defmodule Musix.Strings do
  use Musix.Instrument
  use Musix.Intervals
  use Musix.Note
  use Musix.Chord

  @moduledoc """
  module containing generic functions for strings instruments with frets (default is guitar)
  """

  @strings [%{
               note: "E",
               order: "1",
            },%{
               note: "A",
               order: "2",
            },%{
               note: "D",
               order: "3",
            },%{
               note: "G",
               order: "4",
            },%{
               note: "B",
               order: "5",
            },%{
               note: "E",
               order: "6",
            }]
  @frets 22 #each fret represent a semi-tone
  @name "Guitar"
  @capo 0

  def get_name do
    @name
  end

  def set_name(name) do
    case is_binary(name) do
      true ->
        @name = name
        {:ok}
      _ ->
        {:error, "provide a string"}
    end
  end

  def get_string do
    @string
  end

  def set_string(string) do
    case is_list(string) do
      true ->
        @string = string
        {:ok}
      _ ->
        {:error, "provide a list"}
    end
  end

  def get_frets do
    @frets
  end

  def set_frets(frets) do
      case is_number(frets) do
        true ->
          @frets = frets
          {:ok}
        _ ->
          {:error, "provide a number"}
      end
  end

  def get_capo do
    @capo
  end

  def get_string_with_capo do
    Enum.into(@string, [], fn string ->
      case get_note_above(string, @capo) do
        {:ok, note} ->
          note
        {:error, message} ->
          message
      end
    end)
  end

  def get_frets_with_capo do
    @frets - @capo
  end

  def set_capo(capo) do
    case is_number(capo) do
      true ->
        @capo = capo
        {:ok}
      _ ->
        {:error, "provide a number"}
    end
  end

  def get_positions_on_strings(root) do
    {
      :ok,
    (for string <-
      @strings, into: [], do:
        %{
          description: string,
          positions: get_positions_on_string(root, string.note),
        })
    }
  end

  # depreciated method
  def get_position_on_string(note, string) do
    case get_note_index(note) do
      {:ok, _} ->
        {:ok, get_semi_tones_between(Enum.at(@strings, string).note, note)}
      {:error, message} ->
        {:error, message}
    end
  end

  def get_positions_on_string(note, string_note) do
    case get_semi_tones_between(string_note, note) do
      position ->
        get_positions(position)
    end
  end

  def get_positions(position) do
    case (position <= @frets && position+12 <= @frets) do
      true ->
        [position] ++ get_positions(position+12)
      false ->
        [position]
    end
  end

  defmacro __using__(_) do
    quote do
      import Musix.Strings
    end
  end
end
