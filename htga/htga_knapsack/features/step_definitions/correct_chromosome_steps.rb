
require 'set'

correct_chromosome_hash = {}

Given(/^the chromosome:$/) do |table|
  table = table.raw
  chromosome = Chromosome.new
  chromosome.ones_positions = []
  table.first.each_with_index do |item, i|
    gene = item.to_i
    if gene == 1
      chromosome.ones_positions << i
    end
    chromosome << gene
  end
  correct_chromosome_hash[:chromosome] = chromosome
end

Given(/^the weights:$/) do |table|
  table = table.raw
  weights = []
  table.first.each do |item|
    weights << item.to_f
  end
  correct_chromosome_hash[:weights] = weights
end

Given(/^the max weight being (\d+)$/) do |arg1|
  correct_chromosome_hash[:max_weight] = arg1.to_f
end

When(/^the correction is apply$/) do
   htga = HTGAKnapsack.new pop_size: 2,
                             cross_rate: 0.1,
                             mut_rate: 0.02,
                             num_genes: 7,
                             is_negative_fit: true,
                             is_high_fit: false,
                             values: Array.new(7, 2),
                             weights: correct_chromosome_hash[:weights],
                             max_weight: correct_chromosome_hash[:max_weight],
                             max_generation: 10000
  correct_chromosome_hash[:corrected_chromosome] = htga.correct_chromosome correct_chromosome_hash[:chromosome]
end

Then(/^the resulting chromosome should be:$/) do |table|
  actual_chromosome = correct_chromosome_hash[:corrected_chromosome]
  expected_chromosome = Chromosome.new
  expected_chromosome.ones_positions = []
  table = table.raw
  table.first.each_with_index do |item, i|
    gene = item.to_i
    if gene == 1
      expected_chromosome.ones_positions << i
    end
  end
  (0...expected_chromosome.size).each do |k|
    expect(actual_chromosome[k]).to eq(expected_chromosome[k])
  end
  p "expected_chromosome.ones_positions: #{expected_chromosome.ones_positions}"
  p "actual_chromosome.ones_positions: #{actual_chromosome.ones_positions}"
  expect(expected_chromosome.ones_positions.to_set).to eql(actual_chromosome.ones_positions.to_set)
end

