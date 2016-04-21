# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08

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


When(/^I initialize  the TGA and generate the initial population with continuous variables$/) do
  input[:continuous] = true
  input[:selected_func] = 12
  @tga = TGA.new input
end

When(/^I initialize  the TGA and generate the initial population with non continuous variables$/) do
  input[:continuous] = false
  input[:selected_func] = 12
  @tga = TGA.new input
end

Then(/^all of the chromosomes genes \(values\) for the initial population must be real numbers between their corresponding upper and lower bounds$/) do
  @tga.init_population
  @tga.chromosomes.each do |chromosome|
    puts "=> #{chromosome}"
    i = 0
    chromosome.each do |gene|
      expect(gene).to be_a(Float)
      expect(gene).to be_between(@tga.lower_bounds[i],
                                 @tga.upper_bounds[i]).inclusive
      i += 1
    end
  end
end

Then(/^all of the chromosomes genes \(values\) for the initial population must be integer numbers between their corresponding upper and lower bounds$/) do
  @tga.init_population
  @tga.chromosomes.each do |chromosome|
    puts "=> #{chromosome}"
    i = 0
    chromosome.each do |gene|
      expect(gene).to be_a(Integer)
      expect(gene).to be_between(@tga.lower_bounds[i],
                                 @tga.upper_bounds[i]).inclusive
      i += 1
    end
  end
end
