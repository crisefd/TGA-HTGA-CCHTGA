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

Given(/^the chromosome:$/) do |table|
  chromosome = Chromosome.new
  table = table.raw
  table = table[0]
  table.each do |item|
    chromosome << item.to_i
  end
  args[:chromosome] = chromosome.clone
end

Given(/^a beta value of "([^"]*)"$/) do |arg1|
  beta = arg1.to_f
  args[:beta] = beta
end

When(/^mutation is apply on genes (\d+) and (\d+)$/) do |arg1, arg2|
  i = arg1.to_i
  k = arg2.to_i
  args[:i] = i
  args[:k] = k
end

Then(/^the resulting chromosome must be:$/) do |table|
  chromosome = Chromosome.mutate(args)
  table = table.raw
  table = table[0]
  i = 0
  table.each do |item|
    expect(chromosome[i]).to eq item.to_i
    i += 1
  end
end
