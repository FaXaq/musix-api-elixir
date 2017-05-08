defmodule Musix.IntervalsController do
  use Musix.Web, :controller
  use Musix.Intervals
  use Musix.Note

  def index(conn, _params) do
    json conn, %{
      status: 200,
      desc: get_intervals()
    }
  end

  def get_interval(conn, params) do
    root = params["root"]
    interval = params["interval"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

      {:ok, _} ->
        case validate_interval(interval) do
          {:error, message} ->
            error_400 conn, message
          {:ok, _} ->
            case get_note(root, interval) do
              {:error, message} ->
                error_400 conn, message
              {:ok, note} ->
                json conn, %{
                  status: 200,
                  note: note
                     }
            end
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
