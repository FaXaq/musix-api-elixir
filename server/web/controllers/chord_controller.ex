defmodule Musix.ChordController do
  use Musix.Web, :controller
  use Musix.Chord
  use Musix.Note

  def index(conn, _params) do
    json conn, %{
      status: 200,
      desc: get_chords()
    }
  end

  def get(conn, params) do
    root = params["root"]
    chord = params["chord"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

      #when note is valid look for chord
      {:ok, _} ->
        case get_chord(chord, root) do
          {:ok, chord} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  chord: chord
                    })
          {:error, message} ->
            error_400 conn, message
        end
    end
  end

  def get_all_chords(conn, params) do
    root = params["root"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

      #when note is valid look for chord
      {:ok, _} ->
        case get_chords(root) do
          {:ok, chords} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  chords: chords
                    })
          {:error, message} ->
            error_400 conn, message
        end
    end
  end

  defp error_400(conn, message) do
    put_status(conn, 400)
    |> json(%{
          status: 400,
          message: message
            })
  end
end
