# !~/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require_relative 'chromosome'
require_relative 'roulette'
require_relative 'test_functions'

# @author Cristhian Fuertes
# Main class for the Hybrid-Taguchi Genetic Algorithm
class HTGA
  include Roulette, TestFunctions

  attr_reader :chromosomes, :lower_bounds, :upper_bounds

  def initialize(**input)
    @values = input[:values]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @pop_size = input[:pop_size]
    @cross_rate = input[:cross_rate]
    @mut_rate = input[:mut_rate]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuous = input[:continuous]
    @selected_func = input[:selected_func]
  end

  def start
  end

  def roulette_select
    Roulette.calc_probs @chromosomes
    copied_chromosomes = @chromosomes.clone
    @chromosomes.clear
    (0...@pop_size).each do
      r = rand(0..1000) / 1000.0
      copied_chromosomes.each_index do |i|
        @chromosomes << copied_chromosomes[i] if r < copied_chromosomes[i].prob
      end
    end
  end

  def init_population
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        if @values == 'discrete'
          beta = rand(0..10) / 10.0
        elsif @values == 'uniform distribution'
          beta = rand(0..1000) / 1000.0
        end
        gene = @lower_bounds[i] + beta * (@upper_bounds[i] -
                                                 @lower_bounds[i])
        if @continuous
          chromosome << gene
        else
          chromosome << gene.round
        end
      end
      chromosome.fitness = TEST_FUNCTIONS[@selected_func].call chromosome
      @chromosomes << chromosome
    end
  end
end

if __FILE__ == $PROGRAM_NAME
=begin
   htga = HTGA.new(selected_func: 0, values: 'uniform distribution',
                 continuous: true, pop_size: 5, num_genes: 5,
                  upper_bounds: [5,5,5,5,5], lower_bounds: [-5, -5, -5, -5, -5])
  htga.init_population
=end
end
