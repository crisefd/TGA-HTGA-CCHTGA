# language: en
# file: roulette_selection_steps.rb
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11

Given(/^the positive fitness values of some chromosomes:$/) do |table|
  pending
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
  Roulette.calculate_probabilities @chromosomes
end

Then(/^The calculated probabilities must be:$/) do |table|
  table = table.raw
  table = table[0]
  i = 0
  table.each do |item|
    pr = @chromosomes[i].prob.to_s.slice(0, 5).to_f
    expect(pr).to eq(item.to_f)
    #p "expected #{@chromosomes.prob.round(13)} calculated #{item.to_f}"
    i += 1
  end
end

###################################
Given(/^the negative fitness values of some chromosomes:$/) do |table|
  pending
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
  Roulette.calculate_probabilities @chromosomes
end
