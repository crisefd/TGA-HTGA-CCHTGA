# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-27

correct_genes_test_vars = {}

Given(/^the best chromosome:$/) do |table|
  table = table.raw
  chromosome = Chromosome.new
  table.first.each{ |item| chromosome << item.to_f }
  correct_genes_test_vars[:best_chromosome] = chromosome
end


Given(/^the upper bounds fo the best chromosome are:$/) do |table|
  table = table.raw
  upper_bounds = []
  table.first.each{ |item| upper_bounds << item.to_f }
  correct_genes_test_vars[:upper_bounds] = upper_bounds
end

Given(/^the lower bounds of the best chromosome are:$/) do |table|
  table = table.raw
  lower_bounds = []
  table.first.each{ |item| lower_bounds << item.to_f }
  correct_genes_test_vars[:lower_bounds] = lower_bounds
end

When(/^the correct gene rule is apply$/) do
  cchtga = CCHTGA.new upper_bounds: correct_genes_test_vars[:upper_bounds],
                      lower_bounds: correct_genes_test_vars[:lower_bounds]
  cchtga.best_chromosome = correct_genes_test_vars[:best_chromosome]
  p "best chromo = #{cchtga.best_chromosome}"
  cchtga.correct_best_chromosome_genes
  correct_genes_test_vars[:best_chromosome] = cchtga.best_chromosome

end

Then(/^the corrected chromosome should be:$/) do |table|
  table = table.raw
  corrected_chromosome = Chromosome.new
  table.first.each{ |item| corrected_chromosome << item.to_f }
  expect(correct_genes_test_vars[:best_chromosome]).to eq(corrected_chromosome)
end

Then(/^the corrected genes in chromosome should be in between the upper and lower bounds$/) do
  resulting_chromosome = correct_genes_test_vars[:best_chromosome]
  resulting_chromosome.each_with_index do |gene, i|
    expect(gene).to be_between(correct_genes_test_vars[:lower_bounds][i],
                               correct_genes_test_vars[:upper_bounds][i]).inclusive
  end
end
