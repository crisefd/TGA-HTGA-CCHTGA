# !~/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: htga.rb
# Author: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require_relative 'chromosome'

# @author Cristhian Fuertes
# Main class for the Hybrid-Taguchi Genetic Algorithm
class HTGA
  attr_reader :chromosomes, :lower_bounds, :upper_bounds

  def initialize(**input)
    @values = Array.new input[:values]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @pop_size = input[:pop_size]
    @cross_rate = input[:cross_rate]
    @mut_rate = input[:mut_rate]
    @num_genes = input[:num_genes]
    @chromosomes = []
  end

  def start
  end

  def init_population
    beta = @values[rand(0...@values.size)]
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        chromosome << @lower_bounds[i] + beta * (@upper_bounds[i] -
                                                 @lower_bounds[i])
      end
      @chromosomes << chromosome
    end
  end
end

if __FILE__ == $PROGRAM_NAME

end
