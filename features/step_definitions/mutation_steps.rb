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

When(/^mutation is apply$/) do
  @mutated_chromosome = Chromosome.mutate @chromosome.clone
end

Then(/^the resulting chromosome must be different from the original chromosome$/) do
  p "mutated #{@mutated_chromosome}"
  expect(@chromosome).to_not eq(@mutated_chromosome)
end
