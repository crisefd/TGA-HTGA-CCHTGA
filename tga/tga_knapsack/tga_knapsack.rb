# language: english
# encoding: utf-8
# Program: htga.rb
# creation date: 2016-09-29
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', '..', 'helpers/chromosome.rb')
require File.join(File.dirname(__FILE__), '..', 'tga.rb')

# TGA adaptation for the knapsack 0-1 problem
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class TGAKnapsack < TGA

  # Method to initize attributes
  def initialize(**input)
    @pop_size = input[:pop_size]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuous = input[:continuous]
    @upper_bounds = Array.new @num_genes, 1
    @lower_bounds = Array.new @num_genes, 0
    @knapsack_func = KNAPSACK_FUNCTION
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
    @mating_pool = []
    @new_generation = []
    @num_evaluations = 0
    @best_fit = nil
    @values = input[:values]
    @weights = input[:weights]
    @max_weight = input[:max_weight]
    @optimal_func_val = input[:optimal_func_val]
  end

   # Main method
   # @return [Hash]
  def execute
    output_hash = { best_fit: nil, gen_of_best_fit:0, func_evals_of_best_fit:0}
    @generation = 1
    begin
      init_population
      output_hash[:best_fit] = @best_fit
      output_hash[:func_evals_of_best_fit] = @num_evaluations
      while @generation <= @max_generation
        tournament
        cross_cut_point_mating_pool
        mutate_matingpool
        insert_new_generation
        update_output_hash output_hash
        break if has_stopping_criterion_been_met? output_hash[:best_fit]
        @generation += 1
      end
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
    end
    if @optimal_func_val
      relative_error = (((output_hash[:best_fit] + 1) /
                            (@optimal_func_val + 1)) - 1).abs
      output_hash[:optimal_func_val] = @optimal_func_val
      output_hash[:relative_error] = relative_error
    end
    output_hash
  end
  
   # Updates the output variables
   # @param [Hash] output_hash
   # @return [void]
  def update_output_hash(output_hash)
    if(@best_fit < output_hash[:best_fit] && !@is_high_fit) ||
      (@best_fit > output_hash[:best_fit] && @is_high_fit)
        output_hash[:best_fit] = @best_fit
        output_hash[:gen_of_best_fit] = @generation
        output_hash[:func_evals_of_best_fit] = @num_evaluations
    end
  end

  # Evaluates the fitness of a chromosome for the knapsack problem
  # @param [Chromosome] chromosome
  # @return void
  def evaluate_chromosome(chromosome)
    @num_evaluations += 1
    chromosome.fitness = @knapsack_func.call chromosome, @values, @weights, @max_weight
  end
  
  # Mutates the chromosomes in mating pool
  # @return [void]
  def mutate_matingpool
    (0...@mating_pool.size).each do |i|
      j = rand 0...@num_genes
      chromosome = @mating_pool[i].clone
      gene = chromosome[j] 
      if gene == 0 then gene = 1 else gene = 0 end
      chromosome[j] = gene
      @new_generation << chromosome
    end
  end
  
   # Insert the new chromosomes into the population
  # @return [void]
  def insert_new_generation
    (0...@new_generation.size).each do |i|
      evaluate_chromosome @new_generation[i]
      j = rand 0...@chromosomes.size
      @chromosomes.delete_at j
      @chromosomes << @new_generation[i]
    end
    @mating_pool.clear
    @new_generation.clear
  end
  
  # Method to generate the initial population of chromosomes
  # @return [void]
  def init_population
     (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        gene = rand 0..1
        chromosome << gene
      end
      evaluate_chromosome chromosome
      if @is_high_fit
        @best_fit = chromosome.fitness if @best_fit.nil? || 
                                          chromosome.fitness > @best_fit
      else
        @best_fit = chromosome.fitness if @best_fit.nil? || 
                                          chromosome.fitness < @best_fit
      end
      @chromosomes << chromosome
    end
  end
  
end
if __FILE__ == $PROGRAM_NAME
   # optimum 1130
    # tga = TGAKnapsack.new pop_size: 200,
    #                         num_genes: 24,
    #                         is_negative_fit: false,
    #                         is_high_fit: true,
    #                         values: [150,200,60,60,30,70,15,40,75,20,50,1,35,160,45,40,10,30,10,70,80,12,10,150],
    #                         weights: [[9,153,15,27,23,11,24,73,43,7,4,90,13,50,68,39,52,32,48,42,22,18,30,200]],
    #                         max_weight: [500],
    #                         max_generation: 1000
    # p tga.execute
    
    # optimum 3800
      # weights = [[8, 12, 13, 64, 22, 41],
      #           [8, 12, 13, 75, 22, 41],
      #           [3, 6, 4, 18, 6, 4],
      #           [5, 10, 8, 32, 6, 12],
      #           [5, 13, 8, 42, 6, 20],
      #           [5, 13, 8, 48, 6, 20],
      #           [0, 0, 0, 0, 8, 0],
      #           [3, 0, 4, 0, 8, 0],
      #           [3, 2, 4, 0, 8, 4],
      #           [3, 2, 4, 8, 8, 4]]
    
      # tga = TGAKnapsack.new pop_size: 200,
      #                       num_genes: 6,
      #                       is_negative_fit: false,
      #                       is_high_fit: true,
      #                       values: [100, 600, 1200, 2400, 500, 2000],
      #                       weights: weights,
      #                       max_weight: [80, 96, 20, 36, 44, 48, 10, 18, 22, 24],
      #                       max_generation: 1000
      # p tga.execute
      
       # optimum 6120
      # weights = [ 
      #             [8, 24, 13, 80, 70, 80, 45, 15, 28, 90, 130, 32, 20, 120, 40,30, 20, 6, 3, 180],
      #             [8, 44, 13, 100, 100, 90, 75, 25, 28, 120, 130, 32, 40, 160, 40, 60, 55, 10, 6, 240],
      #             [3, 6, 4, 20, 20, 30, 8, 3, 12, 14, 40, 6, 3, 20, 5, 0, 5, 3, 0, 20],
      #             [5, 9, 6, 40, 30, 40, 16, 5, 18, 24, 60, 16, 11, 30, 25, 10, 13, 5, 1, 80],
      #             [5, 11, 7, 50, 40, 40, 19, 7, 18, 29, 70, 21, 17, 30, 25, 15, 25, 5, 1, 100],
      #             [5, 11, 7, 55, 40, 40, 21, 9, 18, 29, 70, 21, 17, 35, 25, 20, 25, 5, 2, 110],
      #             [0, 0, 1, 10, 4, 10, 0, 6, 0, 6, 32, 3, 0, 70, 10, 0, 0, 0, 0, 0],
      #             [3, 4, 5, 20, 14, 20, 6, 12, 10, 18, 42, 9, 12, 100, 20, 5, 6, 4, 1, 20],
      #             [3, 6, 9, 30, 29, 20, 12, 12, 10, 30, 42, 18, 18, 110, 20, 15, 18, 7, 2, 40],
      #             [3, 8, 9, 35, 29, 20, 16, 15, 10, 30, 42, 20, 18, 120, 20, 20, 22, 7, 3, 50]
      #           ]

      # tga = TGAKnapsack.new pop_size: 200,
      #                       num_genes: 20,
      #                       is_negative_fit: false,
      #                       is_high_fit: true,
      #                       values: [100, 220, 90, 400, 300, 400, 205, 120, 160, 580, 400, 140, 100, 1300, 650, 320, 480, 80, 60, 2550],
      #                       weights: weights,
      #                       max_weight: [550, 700, 130, 240, 280, 310, 110, 205, 260, 275],
      #                       max_generation: 1000
      # p tga.execute
end