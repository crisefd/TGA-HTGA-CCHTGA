#language: en
# encoding: utf-8
# file: TO_matrix.rb
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-31-10
# last modified: 2015-31-10
# version: 0.2
# licence: GPL

require 'rubygems'
require 'bundler/setup'

class TOMatrix < Array
  def initialize(num_columns, num_factors)
    @num_columns = num_columns
    @num_factors = num_factors
    matrix_file = open("taguchi_orthogonal_matrices/L#{num_columns}", 'r')
    lines = matrix_file.readlines
    lines.each do |line|
      line.chomp!
      row = ((line.split ';').map(&:to_i)).slice!(num_factors - 1)...num_columns
      self << row
    end
  end
end
