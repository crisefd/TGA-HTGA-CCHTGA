# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08



Given(/^a population of chromosomes$/) do

end
When(/^a TGA tournament is apply on the population select two chromosomes$/) do
  @tga = TGA.new
  @tga.tournament
  #@tga.tournament
  #@tga.mating_pool
  mating_pool = []
  mating_pool <<2
  mating_pool <<1
  expect(mating_pool.size).to eql(2)
  expect(mating_pool[0]).to_not eql(mating_pool[1])
  #pending # Write code here that turns the phrase above into concrete actions
end

Then(/^add the two differents chromosomes to the mating pool$/) do

end
