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

  #@!attribute lower_bounds
  #	@return [Array] The lower bounds for the genes
  attr_accessor :lower_bounds
  #@!attribute upper_bounds
  #	@return [Array] The upper bounds for the variables
  attr_accessor :upper_bounds
  #@!attribute [w] pop_size
  #	@return [Array] The number of chromosomes in the population
  attr_writer :pop_size
  #@!attribute chromosomes
  #	@return [Array] The population of chromosomes
  attr_accessor :chromosomes
  #@!attribute [w] selected_func
  #	@return [Proc] The selected function to optimize
  attr_writer :selected_func
  #@!attribute [w] optimal_func_val
  #	@return [Float] Function value for the selected function
  attr_writer :optimal_func_val
  #@!attribute [w] is_high_fit
  #	@return [Boolean] A flag indicating if the problem is of maximization or minimization
  attr_writer :is_high_fit
  #@!attribute [r] generation
  #	@return [Integer] The counter variable of the number of generations
  attr_reader :generation
  #@!attribute [r] max_generation
  #	@return [Integer] The maximum allow number of generations
  attr_writer :max_generation
  #@!attribute num_genes
  #	@return [Integer] The length of the chromosome
  attr_accessor :num_genes
  #@!attribute continuous
  #	@return [Boolean] Flag to signal if functions is discrete or continuous
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
      r = random 0.0..1.0
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
        x = random 0...@pop_size
        y = random 0...@pop_size
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
  # @return [Array<Chromosome>] The selected chromosomes
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
  # @return [nil]
  def evaluate_chromosome(chromosome)
    @num_evaluations += 1
    chromosome.fitness = @selected_func.call chromosome
  end

  # Wrapper method for Kernel#rand
  # @param [Range] range 
  # @return Mixed
  # @note This method is used to make it easier to test the code
  def random(range)
    rand(range)
  end
end
