# language: en
# encoding: utf-8
# file: init_population.feature
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-04-21
# last modified:
# version: 0.2
# licence: GPL

Given(/^the chromosome:$/) do |table|
  @tga = TGA.new
  @chromosome = Chromosome.new
  table = table.raw
  table = table[0]
  table.each do |item|
    @chromosome << item.to_i
  end
end

When(/^mutation is apply on the mating pool$/) do
  @tga.mutate_matingpool
end


Then(/^the mutate chromosome changes on one gene$/) do
  

end
