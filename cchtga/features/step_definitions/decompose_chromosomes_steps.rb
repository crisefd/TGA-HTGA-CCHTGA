# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-05-29

decompose_test_vars = {}

Given(/^the population of chromosomes:$/) do |table|
  table = table.raw
  chromosomes = []
  table.each do |row|
    chromosome = Chromosome.new
    row.each do |item|
      chromosome << item.to_f
    end
    chromosomes << chromosome
  end
  decompose_test_vars[:chromosomes] = chromosomes
end

Given(/^a subsystem with the variables:$/) do |table|
  table = table.raw
  subsystem = Subsystem.new
  table.first.each { |item| subsystem << item.to_i }
  decompose_test_vars[:subsystem] = subsystem
end

Given(/^the global lower bounds:$/) do |table|
  table = table.raw
  lower_bounds = []
  table.first.each{ |item| lower_bounds << item.to_f }
  decompose_test_vars[:lower_bounds] = lower_bounds
end

Given(/^the global upper bounds:$/) do |table|
  table = table.raw
  upper_bounds = []
  table.first.each{ |item| upper_bounds << item.to_f }
  decompose_test_vars[:upper_bounds] = upper_bounds
end

When(/^the decompose operation is apply$/) do
  cchtga = CCHTGA.new lower_bounds: decompose_test_vars[:lower_bounds],
                      upper_bounds: decompose_test_vars[:upper_bounds]
  cchtga.chromosomes = decompose_test_vars[:chromosomes]
  decompose_test_vars[:output] = cchtga.decompose_chromosomes decompose_test_vars[:subsystem]
end

Then(/^the resulting subchromosomes should be:$/) do |table|
  table = table.raw
  expected_sub_chromosomes = []
  table.each do |row|
    sub_chromosome = Chromosome.new
    row.each do |item| 
      sub_chromosome << item.to_f
    end
    expected_sub_chromosomes << sub_chromosome
  end
  sub_chromosomes = decompose_test_vars[:output][0]
  expect(sub_chromosomes).to eq(expected_sub_chromosomes)
end

Then(/^with upper and lower bounds:$/) do |table|
  table = table.raw
  expected_lower_bounds = []
  expected_upper_bounds = []
  table[0].each do |item|
    expected_upper_bounds = item.to_f
  end
  table[1].each do |item|
    expected_lower_bounds = item.to_f
  end
  upper_bounds = decompose_test_vars[:output][1]
  lower_bounds = decompose_test_vars[:output][2]
  expect(upper_bounds).to eq(expected_upper_bounds)
  expect(lower_bounds).to eq(expected_lower_bounds)
end

