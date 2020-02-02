# language: en
# file: init_population_steps.rb
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-07
# last modified: 2015-10-07
# version: 0.2
# licence: GPL

input = {}

Given(/^a population size of (\d+)$/) do |size|
  input[:pop_size] = size.to_i
end

Given(/^a number of genes of (\d+)$/) do |num_genes|
  input[:num_genes] = num_genes.to_i
end

Given(/^the upper bounds are$/) do |table|
  table = table.raw
  upper_bounds = []
  table[0].each do |item|
    upper_bounds << item[0].to_f
  end
  input[:upper_bounds] = upper_bounds
end

Given(/^the lower bounds are$/) do |table|
  table = table.raw
  lower_bounds = []
  table[0].each do |item|
    lower_bounds << item[0].to_f
  end
  input[:lower_bounds] = lower_bounds
end

Given(/^the values for beta are "([^"]*)"$/) do |arg1|
  input[:beta_values] = arg1
end


When(/^I initialize  the HTGA and generate the initial population with continuous variables$/) do
  input[:continuous] = true
  input[:selected_func] = 0
  @htga = HTGA.new input
end

When(/^I initialize  the HTGA and generate the initial population with non continuous variables$/) do
  input[:continuous] = false
  input[:selected_func] = 0
  @htga = HTGA.new input
end

Then(/^all of the chromosomes genes \(values\) for the initial population must be real numbers between their corresponding upper and lower bounds$/) do
  @htga.init_population
  @htga.chromosomes.each do |chromosome|
    puts "=> #{chromosome}"
    i = 0
    chromosome.each do |gene|
      expect(gene).to be_a(Float)
      expect(gene).to be_between(@htga.lower_bounds[i],
                                 @htga.upper_bounds[i]).inclusive
      i += 1
    end
  end
end

Then(/^all of the chromosomes genes \(values\) for the initial population must be integer numbers between their corresponding upper and lower bounds$/) do
  @htga.init_population
  @htga.chromosomes.each do |chromosome|
    puts "=> #{chromosome}"
    i = 0
    chromosome.each do |gene|
      expect(gene).to be_a(Integer)
      expect(gene).to be_between(@htga.lower_bounds[i],
                                 @htga.upper_bounds[i]).inclusive
      i += 1
    end
  end
end
