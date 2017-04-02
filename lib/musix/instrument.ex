defmodule Musix.Instrument do
  @moduledoc """
  module containing generic functions for intruments
  """

  defmacro __using__(_) do
    quote do
      import Musix.Instrument
    end
  end
end
