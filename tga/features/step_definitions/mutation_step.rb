# language: en
# encoding: utf-8
# file: init_population.feature
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-04-21
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
  @tga = TGA.new num_genes: 4, upper_bounds: [5, 5, 5, 5], lower_bounds: [-11, -11, -11, -11], continuous: false
  @tga.mating_pool << @chromosome_x
  @tga.mating_pool << @chromosome_y
end

When(/^mutation is apply on the mating pool$/) do
  @tga.mutate_matingpool
end

Then(/^the mutate chromosome changes on one gene$/) do
  countA = 0
  countB = 0
  (0...@tga.mating_pool[1].size).each do |i|
    countA += 1 if (@tga.mating_pool[0][i] == @tga.new_generation[0][i])
  end
  (0...@tga.mating_pool[1].size).each do |i|
    countB += 1 if (@tga.mating_pool[1][i] == @tga.new_generation[1][i])
  end
  expect(countA).to eq(3)
  expect(countB).to eq(3)
end
