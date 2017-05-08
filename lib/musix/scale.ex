defmodule Musix.Scale do
  use Musix.Note
  use Musix.Intervals

  @scales %{
    "chromatic" => %{"intervals" => ["P1","m2","M2","m3","M3","P4","A4","P5","m6","M6","m7","M7"]},
    "major" => %{"intervals" => ["P1","M2","M3","P4","P5","M6","M7"]},
    "minor" => %{"intervals" => ["P1","M2","m3","P4","P5","m6","m7"]},
  }

  # Retrieve all scales definitions
  def get_scales do
    @scales
  end

  # Retrieve all scales definitions with notes
  def get_scales(root) do
    {
      :ok,
      (for {scale_name, _} <-
      @scales, into: %{}, do: {
        scale_name,
        add_scale_to_scales(
          scale_name, build_scale(scale_name, root)
        )})
    }
  end

  # Add scale notes to scale definition
  def add_scale_to_scales(scale, value) do
    case value do
      # add scales notes to scale description in @scales
      {:ok, new} ->
        Map.put(@scales[scale], "notes", new)
      # handle error
      {:error, message} ->
        {:error, message}
    end
  end

  # Check if scale exists
  def validate_scale(scale) do
    case Map.get(@scales, scale) do
      nil ->
        {:error, "scale not found"}
      x ->
        {:ok, x}
    end
  end

  # Retrieve a single scale definition with notes
  def get_scale(scale, root) do
    case Map.has_key?(@scales, scale) do
      true ->
        case build_scale(scale, root) do
          {:ok, built_scale} ->
            {:ok, add_scale_to_scales(scale, {:ok, built_scale})}
          {:error, message} ->
            {:error, message}
        end
      false ->
        {:error, "Unknown scale : " <> scale}
    end
  end

  # Retrieve scales notes
  def build_scale(scale, root) do
    case get_scale_intervals(scale) do
      {:ok, intervals} ->
        {:ok, Enum.into(intervals, [], fn interval ->
            case get_note(root, interval) do
              {:ok, note} ->
                note
              {:error, message} ->
                message
            end
          end)}
      {:error, message} ->
        {:error, message}
    end
  end

  # Retrieve scale intervals
  def get_scale_intervals(scale) do
    case Map.has_key?(@scales, scale) do
      true ->
        case Map.has_key?(@scales[scale], "intervals") do
          true ->
            {:ok, @scales[scale]["intervals"]}
          false ->
            {:error, "Cannot find intervals for scale : " <> scale}
        end
      false ->
        {:error, "Cannot find scale : " <> scale}
    end
  end

  defmacro __using__(_) do
    quote do
      import Musix.Scale
    end
  end
end
