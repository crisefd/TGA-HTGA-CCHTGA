# language: en
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-30

update_subsys_best_chromo_test_vars = {}

Given(/^a subsystem's best chromosome:$/) do |table|
  pending
  table = table.raw
  chromosome = Chromosome.new
  table.first.each{ |item| chromosome << item.to_f }
  subsystem = Subsystem.new [1, 2, 3]
  subsystem.best_chromosome = chromosome
  update_subsys_best_chromo_test_vars[:subsystem] = subsystem
end

Given(/^the subsystem's current best experiences:$/) do |table|
  table = table.raw
  chromosomes = []
  table.each do |row|
    chromosome = Chromosome.new
    row.each do |item|
      chromosome << item.to_f
    end
    chromosomes << chromosome
  end
  update_subsys_best_chromo_test_vars[:subsystem].best_chromosomes_experiences = chromosomes
end

Given(/^the objective function for this problem is the sum of xi$/) do
  update_subsys_best_chromo_test_vars[:subsystem].best_chromosome.fitness = 15
  update_subsys_best_chromo_test_vars[:subsystem].best_chromosomes_experiences[0].fitness = 6 
  update_subsys_best_chromo_test_vars[:subsystem].best_chromosomes_experiences[1].fitness = 16
  update_subsys_best_chromo_test_vars[:subsystem].best_chromosomes_experiences[2].fitness = 15
end

Given(/^the objective functions for this problem is to be minimize$/) do
   update_subsys_best_chromo_test_vars[:is_high_fit] = false
end

When(/^the update of subsystem's best chromosome operation is apply$/) do
  cchtga = CCHTGA.new is_high_fit: update_subsys_best_chromo_test_vars[:is_high_fit]
  (0...3).each do |i|
    cchtga.update_subsystem_best_chromosome update_subsys_best_chromo_test_vars[:subsystem], i
  end
end

Then(/^the updated subsystems's best chromosome should be:$/) do |table|
  table = table.raw
  expected_chromosome = Chromosome.new
  table.first.each{ |item| expected_chromosome << item.to_f }
  expect(update_subsys_best_chromo_test_vars[:subsystem].best_chromosome).to eq(expected_chromosome)
end

