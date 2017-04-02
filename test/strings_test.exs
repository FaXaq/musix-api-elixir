defmodule Musix.StringsTest do
  use ExUnit.Case
  use Musix.Strings

  Test "get position on string" do
    case get_position_on_string("C","E") do
      {atom, x} ->
        assert(atom === :ok)
        assert(x === 8)
    end
  end

  # test "get positions on strings" do
  #   case get_positions_on_strings("C") do
  #     {atom, x} ->
  #       IO.puts x
  #   end
  # end
end
