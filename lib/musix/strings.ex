defmodule Musix.Strings do
  use Musix.Instrument
  use Musix.Intervals
  use Musix.Note
  use Musix.Chord

  @moduledoc """
  module containing generic functions for strings instruments with frets (default is guitar)
  """

  @tuning %{"E" => %{},
            "A" => %{},
            "D" => %{},
            "G" => %{},
            "B" => %{},
            "E" => %{}}
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

  def get_tuning do
    @tuning
  end

  def set_tuning(tuning) do
    case is_list(tuning) do
      true ->
        @tuning = tuning
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

  def get_tuning_with_capo do
    Enum.into(@tuning, [], fn tuning ->
      case get_note_above(tuning, @capo) do
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
    (for {tuning, _} <-
      @tuning, into: %{}, do: {
        tuning,
        add_position_to_tuning(
          tuning, get_position_on_string(root, tuning), root
        )})
    }
  end

  def get_position_on_string(tuning, root) do
    case get_note_index(root) do
      {:ok, _} ->
        {:ok, get_semi_tones_between(root, tuning)}
      {:error, message} ->
        {:error, message}
    end
  end

  # Add chord notes to chord definition
  def add_position_to_tuning(tuning, position, root) do
      case position do
        {:ok, position} ->
          Map.put(@tuning[tuning], root, get_positions(position))
        {:error, message} ->
          Map.put(@tuning[tuning], root, "Couldn't retrieve positions of note " <> root <> " on string " <> root)
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
