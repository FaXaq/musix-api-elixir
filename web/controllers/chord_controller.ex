defmodule Musix.ChordController do
  use Musix.Web, :controller
  use Musix.Chord
  use Musix.Note

  def index(conn, _params) do
    json conn, %{
      status: 200,
      chords: get_chords()
    }
  end

  def major_triad(conn, params) do
    root = params["root"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

        #when note is valid
      {:ok, _} ->
        case get_major_triad(root) do
          {:ok, chord} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  chord: chord,
                    })
          {:error, message} ->
            error_400 conn, message
        end

      _ ->
        error_400 conn, "No idea what happened here"
    end
  end

  def minor_triad(conn, params) do
    root = params["root"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

        #when note is valid
      {:ok, _} ->
        case get_minor_triad(root) do
          {:ok, chord} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  chord: chord
                    })
          {:error, message} ->
            error_400 conn, message
        end

      _ ->
        error_400 conn, "No idea what happened here"
    end
  end

  def aug_triad(conn, params) do
    root = params["root"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

        #when note is valid
      {:ok, _} ->
        case get_augmented_triad(root) do
          {:ok, chord} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  chord: chord
                    })
          {:error, message} ->
            error_400 conn, message
        end

      _ ->
        error_400 conn, "No idea what happened here"
    end
  end

  def dim_triad(conn, params) do
    root = params["root"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

        #when note is valid
      {:ok, _} ->
        case get_diminished_triad(root) do
          {:ok, chord} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  chord: chord
                    })
          {:error, message} ->
            error_400 conn, message
        end

      _ ->
        error_400 conn, "No idea what happened here"
    end
  end

  def error_400(conn, message) do
    put_status(conn, 400)
    |> json(%{
          status: 400,
          message: message
            })
  end
end
