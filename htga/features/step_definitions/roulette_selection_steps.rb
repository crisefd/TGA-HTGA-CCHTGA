# language: en
# encoding: utf-8
# file: roulette_selection_steps.rb
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11
# last modified: 2015-15-11
# version: 0.2
# licence: GPL

Given(/^the positive fitness values of some chromosomes:$/) do |table|
  table = table.raw
  table = table[0]
  @chromosomes = []
  table.each do |item|
    c = Chromosome.new
    c.fitness = item.to_f
    @chromosomes << c
  end
end

When(/^I execute the roulette selection operation for maximization of positive fitness values$/) do
  Roulette.calc_probs(@chromosomes)
end

Then(/^The calculated probabilities must be:$/) do |table|
  table = table.raw
  table = table[0]
  i = 0
  table.each do |item|
    expect(@chromosomes[i].prob.round(10)).to eq(item.to_f.round(10))
    i += 1
  end
end

###################################
Given(/^the negative fitness values of some chromosomes:$/) do |table|
  table = table.raw
  table = table[0]
  @chromosomes = []
  table.each do |item|
    c = Chromosome.new
    c.fitness = item.to_f
    @chromosomes << c
  end
end

When(/^I execute the roulette selection operation for maximization of negative fitness values$/) do
  Roulette.calc_probs @chromosomes, is_negative_fit: true
end
