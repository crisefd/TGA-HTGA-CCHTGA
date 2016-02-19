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
  $ran = Random.new
  attr_reader  :lower_bounds, :upper_bounds
  attr_writer :pop_size
  attr_accessor :chromosomes,

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
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
  end

  def execute
  end

  def cross_individuals
    m = @pop_size
    (0...m).each do
      r = $ran.rand(1.0)
      next if r > @cross_rate
      loop do
        x = rand(0...@pop_size)
        y = rand(0...@pop_size)
        next if x == y
        new_chrom_x, new_chrom_y =
                       Chromosome.crossover(chromosome_x: @chromosomes[x].clone,
                                            chromosome_y: @chromosomes[y].clone,
                                            upper_bounds: @upper_bounds,
                                            lower_bounds: @lower_bounds)
        @chromosomes << new_chrom_x << new_chrom_y
        break
      end
    end
  end

  def mutate_individuals
    m = @chromosomes.size
    (0...m).each do
      r = $ran.rand(1.0)
      next if r > @mut_rate
      x = rand(0...m)
      new_chrom = Chromosome.mutate(@chromosomes[x].clone)
      @chromosomes << new_chrom
    end
  end

  def roulette_select
    Roulette.calc_probs @chromosomes, is_high_fit: @is_high_fit,
                        is_negative_fit: @is_negative_fit
    copied_chromosomes = @chromosomes.clone and @chromosomes.clear
    (0...@pop_size).each do
      r = $ran.rand(1.0)
      copied_chromosomes.each_index do |i|
        @chromosomes << copied_chromosomes[i] if r < copied_chromosomes[i].prob
      end
    end
  end

  def select_next_generation
    #sort in decressing order of fitness values
    @chromosomes.sort! do |left_chrom, right_chrom|
                        right_chrom.fitness <=> left_chrom.fitness
                      end
    @chromosomes.slice!(@pop_size..@chromosomes.size)
  end

  def init_population
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        if @values == 'discrete'
          beta = (Array.new(11){|i| i / 10.0}).sample
        elsif @values == 'uniform distribution'
          beta = $ran.rand(1.0)
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
