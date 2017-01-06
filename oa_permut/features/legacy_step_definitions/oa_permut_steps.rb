# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-11
# last modified: 2015-10-11
# version: 0.2
# licence: GPL
q = 0
n = 0
j = 0
Given(/^the number of levels Q is (.+?)$/) do |q_input|
  q = q_input.to_i
end

Given(/^N is (.+?)$/) do |n_input|
  n = n_input.to_i
end

Given(/^J is (.+?)$/) do |j_input|
  j = j_input.to_i
end

Then(/^the resulting matrix should be:$/) do |table|
  table = table.raw
  ouput_matrix = OAPermut.oa_permut(q, n, j)
  x = 0
  y = 0
  table.each do |row|
    y = 0
    row.each do |item|
      expect(ouput_matrix[x, y]).to eq(item.to_i)
      y += 1
    end
    x += 1
  end
end
