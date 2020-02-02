# language: en
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-05-03

input = {}
Given(/^a number of genes of (\d+):$/) do |arg1|
  input[:num_genes] = arg1.to_i
end

When(/^the calculate divisors function is apply$/) do
  @divisors = []
  cchtga = CCHTGA.new
  cchtga.num_genes = input[:num_genes]
  @num_genes_test = cchtga.num_genes
  @divisors = cchtga.calculate_divisors
end

Then(/^the resulting list of divisors should be$/) do |table|
  @divisors.sort!
  table = table.raw
  expected_list = table.first.map!(&:to_i)
  expect(@divisors).to eq(expected_list)
end
