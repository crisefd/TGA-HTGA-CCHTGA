# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-05-03

Given(/^the amount of gene:$/) do
  table = table.raw
  @num_genes = 0
  table.each do |item|
    if i >= 0
      @num_genes = item[0].to_i
    end
    i += 1
  end
end

When(/^the calculate divisors is apply$/) do
  @divisors = []
  CCHTGA.num_genes = @num_genes
  @divisors = CCHTGA.calculate_divisors.clone
end

Then(/^$/)do
  flag = true
  (0...@divisors.size).each do |i|
    
  end

end
