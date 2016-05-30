# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-29

update_best_chromo_test_vars = {}

Given(/^the global best chromosome:$/) do |table|
  table = table.raw
  chromosome = Chromosome.new
  table.first.each { |item|  chromosome << item.to_f }
  update_best_chromo_test_vars[:best_chromosome] = chromosome
end

Given(/^the subsystem with the variables:$/) do |table|
  table = table.raw
  subsystem = Subsystem.new
  table.first.each{ |item| subsystem << item.to_i }
  update_best_chromo_test_vars[:subsystem] = subsystem
end

Given(/^the subsystem's best chromosome:$/) do |table|
  table = table.raw
  chromosome = Chromosome.new
  table.first.each{ |item| chromosome << item.to_f }
  update_best_chromo_test_vars[:subsystem].best_chromosome = chromosome
end

Given(/^the objective function is the sum of xi$/) do
  #update_best_chromo_test_vars[:selected_func] = lambda do |x|
  #                                                 sum = 0.0
  #                                                 x.each{ |xi| sum += xi } 
  #                                                 sum
  #                                               end
  update_best_chromo_test_vars[:subsystem].best_chromosome.fitness = 3
  update_best_chromo_test_vars[:best_chromosome].fitness = 65
end

Given(/^the objective functions is to be minimize$/) do
  update_best_chromo_test_vars[:is_high_fit] = false
end

When(/^the update of best chromosome operation is apply$/) do
  cchtga = CCHTGA.new is_high_fit: update_best_chromo_test_vars[:is_high_fit]
  # cchtga.selected_func = update_best_chromo_test_vars[:selected_func]
  cchtga.best_chromosome = update_best_chromo_test_vars[:best_chromosome]
  cchtga.update_best_chromosome update_best_chromo_test_vars[:subsystem]
  update_best_chromo_test_vars[:best_chromosome] = cchtga.best_chromosome
end

Then(/^the updated global chromosome should be:$/) do |table|
  table = table.raw
  expected_chromosome = Chromosome.new
  table.first.each{ |item| expected_chromosome << item.to_f }
  expect(update_best_chromo_test_vars[:best_chromosome]).to eq(expected_chromosome)
end

