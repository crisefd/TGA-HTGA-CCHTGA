# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-05-03

input = {}
Given(/^a number of genes of (\d+):$/) do |arg1|
  input[:num_genes] = arg1.to_i
end

When(/^the calculate divisors is apply$/) do
  @divisors = []
  cchtga = CCHTGA.new
  cchtga.num_genes = input[:num_genes]
  @num_genesTest = cchtga.num_genes
  @divisors = cchtga.calculate_divisors.clone
end

Then(/^return a valid list with the divisors$/)do
  flag = true
  (0...@divisors.size).each do |i|
    flag = false if @num_genesTest % @divisors[i] != 0
  end
  expect(flag).to eq(true)
end
