# language: en
# encoding: utf-8
# file: init_population.feature
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-04-23
# last modified:
# version: 0.2
# licence: GPL

Given(/^the chromosomes:$/) do |table|
  table = table.raw
  @chromosome_x = Chromosome.new
  @chromosome_y = Chromosome.new
  i = 0
  table.each do |item|
    if i >= 0
      @chromosome_x << item[0].to_i
      @chromosome_y << item[1].to_i
    end
    i += 1
  end
  # Esta linea se agrega para que funcione para el caso de mutacion y de cruce
  @tga = TGA.new num_genes: 4, upper_bounds: [5, 5, 5, 5], lower_bounds: [-11, -11, -11, -11], continuous: false
  @tga.mating_pool << @chromosome_x
  @tga.mating_pool << @chromosome_y
end

When(/^crossover is apply on the mating pool$/) do
  @tga.cross_cut_point_mating_pool
end

Then(/^the resulting chromosomes must have swapped their right sides$/) do
  cut_point = -1
  size = @chromosome_x.size
  (0...size).each do |i|
    if @chromosome_x[i] != @crossed_chromosome_x[i]
      cut_point = i
      break
    end
  end
  if cut_point < size - 1
    expect(@crossed_chromosome_x[(cut_point + 1)...size]).to eq(@chromosome_y[(cut_point + 1)...size])
    expect(@crossed_chromosome_y[(cut_point + 1)...size]).to eq(@chromosome_x[(cut_point + 1)...size])
  end
  expect(@crossed_chromosome_x[cut_point]).to_not eq(@chromosome_x)
  expect(@crossed_chromosome_y[cut_point]).to_not eq(@chromosome_y)
end
