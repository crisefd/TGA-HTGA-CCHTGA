# language: en
# encoding: utf-8
# program: tga.rb
# creation date: 2016-03-07
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# Main class for the Traditional Genetic Algorithm
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class TGA < BaseGA

  # @!attribute [r] mating_pool
  # @return [Array] The subset of chromosomes selected to be crossed/mutated
  attr_reader :mating_pool
  # @!attribute [r] new_generation
  # @return [Array] The next generation's chromosomes
  attr_reader :new_generation
  # @!attribute [r] num_genes
  # @return [Integer] The size of the chromosome
  attr_reader :num_genes
  # @!attribute [r] chromosomes
  # @return [Array<Chromosome>] The population of chromosomes
  attr_reader :chromosomes
  # @!attribute [r] pop_size
  # @return [Array<Chromosome>] The number of chromosomes in the population
  attr_reader :pop_size
  
  # @param [Hash] input The input values for the algorithm
  # @option input [String] :beta_values The type of random numbers (discrete | uniform distribution) to be use in {#init_population}
  # @option input [Array] :upper_bounds The upper bounds for the genes
  # @option input [Array] :lower_bounds The lower bounds for the genes
  # @option input [Integer] :pop_size The number of chromosomes the population
  # @option input [Integer] :num_genes The number of genes in a chromosome
  # @option input [Boolean] :continuous Flag to indicate if the problem being solved is continuous or discrete
  # @option input [Integer] :selected_function The number of the test function (f1, f2,...,f15) to solved
  # @option input [Boolean] :is_high_fit Flag to indicate if the problem to be resolved is a maximization or minimization problem
  # @option input [Float] :optimal_func_val The best known value for the problem being solved
  # @option input [Integer] :max_generation The max number of generations
  def initialize(**input)
    @optimal_func_val = OPTIMAL_FUNCTION_VALUES[input[:selected_func] - 1]
    @optimal_func_val = input[:optimal_func_val] if @optimal_func_val.nil?
    @pop_size = input[:pop_size]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuous = input[:continuous]
    input[:selected_func] = 0 if input[:selected_func].nil?
    @selected_func = TEST_FUNCTIONS[input[:selected_func] - 1]
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
    @mating_pool = []
    @new_generation = []
    @num_evaluations = 0
    @best_fit = nil
  end

  # Main method
  # @return [Hash] The output variables: best fitness, number of generations, number of fitness evaluation, relative error and optimal value
  def execute
    output_hash = {}
    @generation = 1
    begin
      init_population
      while @generation <= @max_generation
        tournament
        cross_cut_point_mating_pool
        mutate_matingpool
        insert_new_generation
        break if @best_fit == @optimal_func_val
        @generation += 1
        relative_error = (((@best_fit + 1) / (@optimal_func_val + 1)) - 1).abs
        output_hash.merge! best_fit: @best_fit, gen_of_best_fit: @gen_of_best_fit,
                           func_evals_of_best_fit: @func_evals_of_best_fit,
                           optimal_func_val: @optimal_func_val,
                           relative_error: relative_error
      end
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
    end
    p output_hash
    output_hash
  end

  # Method to select chromosomes by tournamet (default  k = 2)
  # @return [nil]
  def tournament
    k = 2
    x = -1
    y = -1
    prev_chromo = -1
    k.times do
      until (x != y) && (x != prev_chromo) && (y != prev_chromo)
        x = rand(0...@pop_size)
        y = rand(0...@pop_size)
      end
      if @is_high_fit
        if @chromosomes[x].fitness <= @chromosomes[y].fitness
          @mating_pool << @chromosomes[y]
          prev_chromo = y
        elsif @chromosomes[y].fitness < @chromosomes[x].fitness
          @mating_pool << @chromosomes[x]
          prev_chromo = x
        end
      else
        if @chromosomes[x].fitness <= @chromosomes[y].fitness
          @mating_pool << @chromosomes[x]
          prev_chromo = x
        elsif @chromosomes[y].fitness < @chromosomes[x].fitness
          @mating_pool << @chromosomes[y]
          prev_chromo = y
        end
      end
    end
  end

  # Crosses the chrosomes in the mating pool
  # @return [nil]
  def cross_cut_point_mating_pool
    cut_point = rand(0...@num_genes)
    chromosome_x = @mating_pool[0].clone
    chromosome_y = @mating_pool[1].clone
    (cut_point...@num_genes).each do |i|
      temp_cut_x = chromosome_x[i]
      temp_cut_y = chromosome_y[i]
      chromosome_x[i] = temp_cut_y
      chromosome_y[i] = temp_cut_x
    end
    @new_generation << chromosome_y << chromosome_x
  end

  # Mutates the chromosomes in the mating pool
  # @return [nil]
  def mutate_matingpool
    (0...@mating_pool.size).each do |i|
      gene = -1
      mutate_point = rand(0...@num_genes)
      chromosome = @mating_pool[i].clone
      if @continuous
        gene = rand(lower_bounds[0].to_f..upper_bounds[0].to_f)
      else
        gene = rand(lower_bounds[0].to_i..upper_bounds[0].to_i)
      end
      chromosome[mutate_point] = gene
      @new_generation << chromosome
    end
  end

  # Inserts the new chromosomes into the population
  # @return [nil]
  def insert_new_generation
    (0...@new_generation.size).each do |i|
      evaluate_chromosome @new_generation[i]
      j = rand 0...@chromosomes.size
      @chromosomes.delete_at j
      verify_best_fit @new_generation[i]
      @chromosomes << @new_generation[i]
    end
    @mating_pool.clear
    @new_generation.clear
  end

  # Verifies if the chromosome has a better fitness
  # @param [Chromosome] chromosome
  # @return [nil]
  def verify_best_fit(chromosome)
    if @is_high_fit
      @best_fit = chromosome.fitness if @best_fit.nil? || chromosome.fitness > @best_fit
      @gen_of_best_fit = @generation
      @func_evals_of_best_fit = @num_evaluations
    else
      @best_fit = chromosome.fitness if @best_fit.nil? || chromosome.fitness < @best_fit
      @gen_of_best_fit = @generation
      @func_evals_of_best_fit = @num_evaluations
    end
  end

  # Generates the initial population of chromosomes
  # @return [nil]
  def init_population
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        gene = nil
        if @continuous
          gene = rand(lower_bounds[i].to_f..upper_bounds[i].to_f)
        else
          gene = rand(lower_bounds[i].to_i..upper_bounds[i].to_i)
        end
        chromosome << gene
      end
      evaluate_chromosome chromosome
      verify_best_fit chromosome
      @chromosomes << chromosome
    end
  end
end

if __FILE__ == $PROGRAM_NAME
end
