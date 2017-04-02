defmodule Musix.NoteController do
  use Musix.Web, :controller
  use Musix.Note

  def index(conn, _) do
    json conn, %{
      status: 200,
      notes: get_notes()
    }
  end

  def flatten(conn, params) do
    note = params["note"]

    case get_note_index(note) do
        #when note is invalid
      {:error, message} ->
        error_400 conn, message

      #when note is valid
      {:ok, _} ->
        case get_flattened_note(note) do
          {:ok, x} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  note: x
                    })
          {:error, message} ->
            error_400 conn, message
        end
      _ ->
        error_400 conn, "No idea what happened here"
    end
  end

  def sharpen(conn, params) do
    note = params["note"]

    case get_note_index(note) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

        #when note is valid
      {:ok, _} ->
        case get_sharpened_note(note) do
          {:ok, x} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  note: x
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
