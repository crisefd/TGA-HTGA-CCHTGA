# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes & Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'helpers/selection_methods.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/roulette.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/SUS.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/test_functions.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/validator.rb')

# @author Cristhian Fuertes
# @author Oscar Tigreros
# Mixin class for TGA, HTGA & CCHTGA
class BaseGA
  # Modules for roulette selection operation and test functions
  extend Selection
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

  # @param [Hash] input, hash list for the initialization
  def initialize(**input)
    @beta_values = input[:beta_values]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @pop_size = input[:pop_size]
    @cross_rate = input[:cross_rate]
    @mut_rate = input[:mut_rate]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuous = input[:continuous]
    input[:selected_func] = 0 if input[:selected_func].nil?
    @selected_func = TEST_FUNCTIONS[input[:selected_func] - 1]
    @optimal_func_val = OPTIMAL_FUNCTION_VALUES[input[:selected_func] - 1]
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
    @num_evaluations = 0
  end

  # Roulette selection operation method

  # @return [Integer] offset of the selected chromosomes
  def roulette_select
    Selection::Roulette.calculate_probabilities @chromosomes, is_high_fit: @is_high_fit
    selected_chromos_indexes = []
    fail "what?" if @chromosomes.size != @pop_size
    num_selections = @pop_size * @cross_rate
    while selected_chromos_indexes.size < num_selections do
      r = rand 0.0..1.0
      #p "roulette_select rand #{r}"
      m = @pop_size - 1
      (0...m).each do |i|
        a = @chromosomes[i].prob
        b = @chromosomes[i + 1].prob
        p "i = #{i}" if i%10 == 0
        
        if !(a < b)
          p "#{a} is not < #{b}" 
          fail 'a is not < b'
        end
        selected_chromos_indexes << i if r === (a...b)
       #selected_chromos_indexes << i if r >= @chromosomes[i].prob r < @chromosomes[i + 1].prob
      end
    end    
    # copied_chromosomes = @chromosomes.clone and @chromosomes.clear
    # r = rand(0.0..1.0)
    # rejected_chromosomes = []
    # (0...@pop_size).each do |i|
    #   if r < copied_chromosomes[i].prob
    #     @chromosomes << copied_chromosomes[i]
    #   else
    #     rejected_chromosomes << copied_chromosomes[i]
    #   end
    # end
    # selected_offset = @chromosomes.size
    # @chromosomes += rejected_chromosomes.reverse!
    # selected_offset
    selected_chromos_indexes
  end
  
  def tournament_select
    k = @pop_size * @cross_rate
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
        if (fit_chromo_x >= fit_chromo_y) then selected_chromos_indexes << x else selected_chromos_indexes << y end
      else
        if (fit_chromo_x <= fit_chromo_y) then selected_chromos_indexes << x else selected_chromos_indexes << y end
      end
    end
    selected_chromos_indexes
  end


  # calculate the fitness of bunch of chromosomes
  def evaluate_chromosomes(*chromosomes)
    # p chromosomes_clust.size
    (0...chromosomes.size).each do |i|
      chromosomes[i].fitness = @selected_func.call chromosomes[i]
      @num_evaluations += 1
    end
  end

  # SUS selection operation method
  # @return [Array<Chromosome>] selected chromosomes
  def sus_select
   # pointers = Selection::SUS.sample @chromosomes, @pop_size * @cross_rate,
    #                                 is_high_fit: @is_high_fit,
     #                                is_negative_fit: @is_negative_fit
    pointers = Selection::SUS.sample @chromosomes, @pop_size,
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
  # @note fitness equals the function value
  def evaluate_chromosome(chromosome)
    @num_evaluations += 1
    chromosome.fitness = @selected_func.call chromosome
  end
end
