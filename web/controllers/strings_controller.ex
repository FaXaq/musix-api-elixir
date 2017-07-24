defmodule Musix.StringsController do
  use Musix.Web, :controller
  use Musix.Note
  use Musix.Strings

  def index(conn, _params) do
    json conn, %{
      status: 200,
      desc: get_name()
    }
  end

  def get_positions_on_strings(conn, params) do
    root = params["root"]
    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

      #when note is valid look for chord
      {:ok, _} ->
        case get_positions_on_strings(root) do
          {:ok, position} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  positions: position
                    })
          {:error, message} ->
            error_400 conn, message
        end
    end
  end

  def get_fret_number(conn, _params) do
    put_status(conn, 200)
    |> json(%{
          status: 200,
          frets: get_frets()
            })
  end

  defp error_400(conn, message) do
    put_status(conn, 400)
    |> json(%{
          status: 400,
          message: message
            })
  end
end
