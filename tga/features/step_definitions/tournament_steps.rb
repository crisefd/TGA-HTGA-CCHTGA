# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08

Given(/^a population of any five chromosomes$/) do
  @tga = TGA.new pop_size: 5, selected_func: 12
  @tga.chromosomes = []
  (0..4).each do
    chr = Chromosome.new
    (0..5).each do
      chr << rand(0..10)
    end
    @tga.evaluate_chromosome chr
    @tga.chromosomes << chr
  end
end

When(/^tournament is apply on the population$/) do
  @tga.tournament
end

Then(/^two different chromosomes must be randomly chosen$/) do
  expect(@tga.mating_pool[0]).not_to eq(@tga.mating_pool[1])
end
