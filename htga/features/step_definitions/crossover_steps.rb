# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-11
# last modified: 2015-10-11
# version: 0.2
# licence: GPL
args = {}
Given(/^the chromosomes:$/) do |table|
  table = table.raw
  @chromosome_x = Chromosome.new
  @chromosome_y = Chromosome.new
  i = 0
  table.each do |item|
    if i > 0
      @chromosome_x << item[0].to_i
      @chromosome_y << item[1].to_i
    end
    i += 1
  end
  args[:chromosome_x] = @chromosome_x.clone
  args[:chromosome_y] = @chromosome_y.clone
end

Given(/^the upper bounds are:$/) do |table|
  table = table.raw
  table = table[0]
  upper_bounds = []
  table.each do |item|
    upper_bounds << item.to_i
  end
  args[:upper_bounds] = upper_bounds
end

Given(/^the lower bounds are:$/) do |table|
  table = table.raw
  table = table[0]
  lower_bounds = []
  table.each do |item|
    lower_bounds << item.to_i
  end
  args[:lower_bounds] = lower_bounds
end

When(/^we apply crossover on the chromosomes$/) do
  args[:continuous] = true
  @crossed_chromosome_x, @crossed_chromosome_y = HTGA.crossover args
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
