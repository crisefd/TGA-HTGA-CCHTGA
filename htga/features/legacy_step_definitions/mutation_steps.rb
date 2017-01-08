# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-11
# last modified: 2015-10-11
# version: 0.2
# licence: GPL

Given(/^the chromosome:$/) do |table|
  @chromosome = Chromosome.new
  table = table.raw
  table = table[0]
  table.each do |item|
    @chromosome << item.to_i
  end
end

When(/^mutation is apply on two genes of the chromosome$/) do
  @htga = HTGA.new continuous: true
  @mutated_chromosome = @htga.mutate @chromosome.clone
end

Then(/^the changed genes must be closer stepwise in the resulting chromosome$/) do
  i, k, cont = 0, 0, 0
  @mutated_chromosome.each_index do |index|
    if @mutated_chromosome[index] != @chromosome[index]
      if cont == 1
        k = index
        break
      elsif  cont == 0
        i = index
      end
      cont += 1
    end
  end
  prev_distance = (@chromosome[i] - @chromosome[k]).abs
  new_distance = (@mutated_chromosome[i] - @mutated_chromosome[k]).abs
  p "prev_distance = #{prev_distance} new_distance = #{new_distance}"
  expect(new_distance).to be <= prev_distance
end
