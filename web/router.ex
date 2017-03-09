defmodule Musix.Router do
  use Musix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Musix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1/", Musix do
    pipe_through :api

    get "/", PageController, :api_description

    get "/notes", NoteController, :index
    get "/notes/flatten/:note", NoteController, :flatten
    get "/notes/sharpen/:note", NoteController, :sharpen
  end
end
