# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08


Given(/^a population of  (\d+) chromosomes$/) do |arg|
  @tga = TGA.new pop_size: arg.to_i
  @tga.chromosomes = 

end
When(/^tournament is apply on the population select two diferents chromosomes at random$/) do
  TGA.tournament

end

Then(/^Two differents chromosomes should be added to the mating pool$/) do
  expect(@mating_pool[0]).to_not eql(@mating_pool[1])
end
