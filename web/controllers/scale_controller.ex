defmodule Musix.ScaleController do
  use Musix.Web, :controller
  use Musix.Scale
  use Musix.Note

  def index(conn, _params) do
    json conn, %{
      status: 200,
      desc: get_scales()
    }
  end

  def get(conn, params) do
    root = params["root"]
    scale = params["scale"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

      #when note is valid look for scale
      {:ok, _} ->
        case get_scale(scale, root) do
          {:ok, scale} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  scale: scale
                    })
          {:error, message} ->
            error_400 conn, message
        end
    end
  end

  def get_scales(conn, params) do
    root = params["root"]

    case get_note_index(root) do
      #when not is invalid
      {:error, message} ->
        error_400 conn, message

      #when note is valid look for scale
      {:ok, _} ->
        case get_scales(root) do
          {:ok, scales} ->
            put_status(conn, 200)
            |> json(%{
                  status: 200,
                  scales: scales
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
