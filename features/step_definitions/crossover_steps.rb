# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-11
# last modified: 2015-10-11
# version: 0.2
# licence: GPL
args = {}
Given(/^the chromosomes:$/) do |table|
  table = table.raw
  chromosome_x = Chromosome.new
  chromosome_y = Chromosome.new
  i = 0
  table.each do |item|
    if i > 0
      chromosome_x << item[0].to_i
      chromosome_y << item[1].to_i
    end
    i += 1
  end
  args[:chromosome_x] = chromosome_x
  args[:chromosome_y] = chromosome_y
end

When(/^I apply crossover with a beta value of "([^\"]*)$/) do |arg1|
  beta = arg1.to_f
  args[:beta] = beta
end

When(/^a k value of (\d+)$/) do |arg1|
  k = arg1.to_i
  args[:k] = k
end

When(/^I apply crossover with a beta value of "([^"]*)"$/) do |arg1|
  beta = arg1.to_f
  args[:beta] = beta
end

When(/^an upper bound value of "([^"]*)"$/) do |arg1|
  upper_bound = arg1.to_i
  args[:upper_bound] = upper_bound
end

When(/^a lower bound value of "([^"]*)"$/) do |arg1|
  lower_bound = arg1.to_i
  args[:lower_bound] = lower_bound
end

Then(/^the resulting chromosomes must be:$/) do |table|
  chromosome_x, chromosome_y = Chromosome.crossover args
  table = table.raw
  i = 0
  table.each do |item|
    if i > 0
      expect(chromosome_x[i - 1]).to eq item[0].to_i
      expect(chromosome_y[i - 1]).to eq item[1].to_i
    end
    i += 1
  end
end
