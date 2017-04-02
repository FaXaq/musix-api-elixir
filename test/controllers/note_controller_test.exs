defmodule Musix.NoteControllerTest do
  use Musix.ConnCase

  test "GET /api/v1", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 404)
  end
end
