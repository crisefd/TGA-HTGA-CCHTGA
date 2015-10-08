# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-07
# last modified: 2015-10-07
# version: 0.2
# licence: GPL

Given /^a population size of (\d+)$ / do |size|
  @pop_size = size
end

And /^a number of genes of (\d+)$/ do |num_genes|
  @num_genes = num_genes
end

And /^the upper bounds are$/ do |table|
  @upper_bounds = Array.new
  table.each do |item|
    @upper_bounds << item.to_i
  end
end

And /^the lower bounds are$/ do |table|
  @lower_bounds = Array.new
  table.each do |item|
    @lower_bounds << item.to_i
  end
end

And /^the list of values is$/ do |table|
  @values = Array.new
  table.each do |item|
    @values << item.to_f
  end
end

Wnen /^I create  the chromosomes$/ do

end

Then /^all of the values,the genes, must be integer numbers between their corresponding upper and lower bounds$/ do

end
