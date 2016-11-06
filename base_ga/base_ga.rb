# encoding: utf-8
# language: en
# program: base_ga.rb
# creation date: 2015-10-05
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'helpers/roulette.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/sus.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/test_functions.rb')

# Mixin base class for TGA, HTGA and CCHTGA
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class BaseGA
  # Modules for roulette, SUS  test functions
  extend Roulette, SUS
  include TestFunctions

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

  # Checks if the known best fitness value has been reached
  # @param [Float] best_fit
  # @return [Bool]
  def has_stopping_criterion_been_met?(best_fit)
    return false if @optimal_func_val.nil?
    if @is_high_fit
      answer = best_fit >= @optimal_func_val
    else
      answer = best_fit <= @optimal_func_val
    end
    answer
  end

  # Roulette selection operation method
  # @return [Array] selected chromosome indexes
  def roulette_select
    Roulette.calculate_probabilities @chromosomes
    selected_chromos_indexes = []
    num_selections = @pop_size * @cross_rate
    while selected_chromos_indexes.size < num_selections
      r = rand 0.0..1.0
      m = @pop_size - 1
      (0...m).each do |i|
        a = @chromosomes[i].prob
        b = @chromosomes[i + 1].prob
        if !(a <= b)
          p "#{a} is not < #{b}"
          fail 'a is not < b'
        end
        selected_chromos_indexes << i if r >= a && r < b
        selected_chromos_indexes << m if r == 1.0
      end
    end
    selected_chromos_indexes
  end
  
  # Tournament selection method
  # @param [Integer] k
  # @return [Array] selected chromosome indexes
  # @note This function is unused, should be decreated soon
  def tournament_select(k)
    selected_chromos_indexes = []
    1.upto(k) do
      x = -1
      y = -1
      loop do
        x = rand 0...@pop_size
        y = rand 0...@pop_size
        break if x != y
      end
      fit_chromo_x = @chromosomes[x].fitness
      fit_chromo_y = @chromosomes[y].fitness
      if @is_high_fit
        if (fit_chromo_x >= fit_chromo_y) then 
          selected_chromos_indexes << x 
        else 
          selected_chromos_indexes << y 
        end
      else
        if (fit_chromo_x <= fit_chromo_y) then 
          selected_chromos_indexes << x 
        else 
          selected_chromos_indexes << y 
        end
      end
    end
    fail "tournament size error" if selected_chromos_indexes.size != k
    selected_chromos_indexes
  end

  # SUS selection operation method
  # @return [Array<Chromosome>] selected chromosomes
  def sus_select
    pointers = SUS.sample @chromosomes, @pop_size,
    is_high_fit: @is_high_fit,
    is_negative_fit: @is_negative_fit
    k = 0
    selected_chromosomes = []
    pointers.each do |ptr|
      loop do
        break if @chromosomes[k].fit_sum >= ptr
        k += 1
      end
      selected_chromosomes << @chromosomes[k]

    end
    fail 'wrong number of selected chromosomes' if selected_chromosomes.size != @pop_size
    selected_chromosomes
  end

  # Method to evaluate an assign a fitness value to a chromosome
  # @param [Chromosome] chromosome
  # @return [void]
  def evaluate_chromosome(chromosome)
    @num_evaluations += 1
    chromosome.fitness = @selected_func.call chromosome
  end
end
