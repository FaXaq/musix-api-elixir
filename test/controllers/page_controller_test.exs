defmodule Musix.PageControllerTest do
  use Musix.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 404) =~ "Page not found"
  end
end
