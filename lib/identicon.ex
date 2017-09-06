defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)  
    
    #Iterate every element inside collection
    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(image) do

    %Identicon.Image{grid: grid} = image

    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(image) do
    %Identicon.Image{grid: grid} = image
    grid = Enum.filter grid, fn({code, _index}) ->
      # calcualte remainer if divided by 2
      rem(code, 2) == 0    
      # will return grid with even number
    end


    #Return an updated version of grid
    %Identicon.Image{image | grid: grid}
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
