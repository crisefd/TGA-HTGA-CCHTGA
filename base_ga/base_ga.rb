# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes & Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'helpers/roulette.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/test_functions.rb')

# @author Cristhian Fuertes
# @author Oscar Tigreros
# Mixin class for TGA, HTGA & CCHTGA
class BaseGA
  # Modules for roulette selection operation and test functions
  include Roulette, TestFunctions

  # @!attribute [Array] lower_bounds, lower bounds for the variables
  attr_accessor :lower_bounds
  # @!attribute [Array] upper_bounds, upper bounds for the variables
  attr_accessor :upper_bounds
  # @!attribute [Array] pop_size, the number of chromosomes
  attr_writer :pop_size
  # @!attribute [Array] chromosomes, the candidate solutions
  attr_accessor :chromosomes
  # @!attribute [Proc] selected_func, the selected function to optimize
  attr_writer :selected_func
  # @!attribute [Float], the optimal function value for the selected function
  attr_writer :optimal_func_val
  # @!attribute [Boolean] is_high_fit, a flag indicating if what is sought is a
  # high fitness
  attr_writer :is_high_fit
  # @!attribute [Integer] generation, the counting variables of the number of
  # generations
  attr_reader :generation
  # @!attribute [Integer] max_generation, the maximum allow number of
  # generations
  attr_writer :max_generation
  # @!attribute [Integer] num_genes, the length of the chromosome
  attr_accessor :num_genes
  # @!attribute [Boolean] continuous, flag to signal if functions is discrete or
  # continuous
  attr_accessor :continuous

  # Roulette selection operation method
  # @return [Integer] offset of the selected chromosomes
  def roulette_select
    fail "pop size incorrect, expected #{pop_size} found #{@chromosomes.size}" unless @pop_size == @chromosomes.size
    Roulette.calc_probs @chromosomes, is_high_fit: @is_high_fit,
                                      is_negative_fit: @is_negative_fit
    copied_chromosomes = @chromosomes.clone and @chromosomes.clear
    r = rand(0.0..1.0)
    rejected_chromosomes = []
    (0...@pop_size).each do |i|
      if r < copied_chromosomes[i].prob
        @chromosomes << copied_chromosomes[i]
      else
        rejected_chromosomes << copied_chromosomes[i]
      end
    end
    fail "pop size after selection incorrect, expected #{@chromosomes.size} <= #{pop_size}" unless @pop_size >= @chromosomes.size
    selected_offset = @chromosomes.size
    @chromosomes += rejected_chromosomes.reverse!
    selected_offset
  end

  # Method to evaluate an assign a fitness value to a chromosome
  # @param [Chromosome] chromosome
  # @note fitness equals the function value
  def evaluate_chromosome(chromosome)
    @num_evaluations += 1
    chromosome.fitness = @selected_func.call chromosome
  end

end
