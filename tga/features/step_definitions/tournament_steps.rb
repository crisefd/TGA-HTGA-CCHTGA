# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08



Given(/^a population of chromosomes$/) do

end

When(/^tournament is apply on the population select two chromosomes$/) do
  @tga = TGA.new
  @tga.tournament
end

Then(/^add the two differents chromosomes to the mating pool$/) do
  #@tga.tournament
  @tga.mating_pool

  expect(mating_pool.size).to eql(2)
  expect(mating_pool[0]).to_not eql(mating_pool[1])
end
