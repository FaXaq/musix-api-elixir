defmodule Musix.PageController do
  use Musix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def api_description(conn, _params) do
    render conn, "index.html"
  end
end
