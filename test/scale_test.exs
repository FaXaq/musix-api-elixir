defmodule Musix.ScaleTest do
  use ExUnit.Case
  use Musix.Scale

  test "get all scales" do
    case get_scales() do
      x ->
        assert(is_map(x))
    end
  end

  test "get major scale" do
    case get_scale("major","C") do
      {atom, scale} ->
        assert(atom == :ok)
        assert(["C","D","E","F","G","A","B"] === scale["notes"])
    end

    case get_scale("major","Cs") do
      {atom, scale} ->
        assert(atom == :ok)
        assert(["Cs","Ds","Es","Fs","Gs","As","Bs"] === scale["notes"])
    end
  end

  test "get minor scale" do
    case get_scale("minor","C") do
      {atom, scale} ->
        assert(atom == :ok)
        assert(["C","D","Eb","F","G","Ab","Bb"] === scale["notes"])
    end
  end
end
