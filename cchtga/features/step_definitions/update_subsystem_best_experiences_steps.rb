# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-30

update_subsys_exp_test_vars = {}


Given(/^the subsystem's population of chromosomes:$/) do |table|
  pending
  table = table.raw
  subsystem = Subsystem.new [1, 2, 3]
  subsystem.chromosomes = []
  table.each do |row|
    chromosome = Chromosome.new
    row.each do |item|
      chromosome << item.to_f
    end
    subsystem.chromosomes << chromosome
  end
  update_subsys_exp_test_vars[:subsystem] = subsystem
end

Given(/^the current subsystem's best experiences of chromosomes:$/) do |table|
  table = table.raw
  update_subsys_exp_test_vars[:subsystem].best_chromosomes_experiences = []
  table.each do |row|
    chromosome = Chromosome.new
    row.each do |item|
      chromosome << item.to_f
    end
    update_subsys_exp_test_vars[:subsystem].best_chromosomes_experiences << chromosome
  end
end

Given(/^the objective function for this problem is the sum of zi$/) do
  update_subsys_exp_test_vars[:subsystem].chromosomes[0].fitness = 9
  update_subsys_exp_test_vars[:subsystem].chromosomes[1].fitness = 18
  update_subsys_exp_test_vars[:subsystem].chromosomes[2].fitness = 21
  
  update_subsys_exp_test_vars[:subsystem].best_chromosomes_experiences[0].fitness = 4
  update_subsys_exp_test_vars[:subsystem].best_chromosomes_experiences[1].fitness = 24
  update_subsys_exp_test_vars[:subsystem].best_chromosomes_experiences[2].fitness = 24
end

Given(/^the objective function value for this problem is to be minimize$/) do
  update_subsys_exp_test_vars[:is_high_fit] = false
end

When(/^the update of subsystem's best experiences of chromosomes operation is apply$/) do
  cchtga = CCHTGA.new is_high_fit: update_subsys_exp_test_vars[:is_high_fit]
  
  (0...3).each do |i|
    cchtga.update_subsystem_best_experiences update_subsys_exp_test_vars[:subsystem], i
  end
end

Then(/^the updated subsystems's best experiences of chromosomes should be:$/) do |table|
  table = table.raw
  expected_experiences = []
  table.each do |row|
    chromosome = Chromosome.new
    row.each do |item|
      chromosome << item.to_f
    end
    expected_experiences << chromosome
  end
  expect(update_subsys_exp_test_vars[:subsystem].best_chromosomes_experiences).to eq(expected_experiences)
end

