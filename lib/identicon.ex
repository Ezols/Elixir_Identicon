defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid

  end

  def build_grid(image) do
    
    # Get access to hex content
    %Identicon.Image{hex: hex} = image
    # Pass hex to pipes
    grid = hex
      # create a row for grid of 3 elements
      |> Enum.chunk(3)
      # Map all elements passed in, and mirror rows, creating 5 element grid
      |> Enum.map(&mirror_row/1)
      # Put all stuff in one list
      |> List.flatten
      # Turns list elemts into tuple which consists two elements,
      # first elemnt is element from list, second element is index in the list
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}

  end

  def mirror_row(row) do
    # [145, 26, 200]
    [first, second | _tail] = row

    # [145, 26, 200, 46, 145]
    row ++ [second, first]
  end

  def pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image

    %Identicon.Image{image | color: {r, g, b}}    
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

end
