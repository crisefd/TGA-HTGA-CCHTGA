# language: english
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-09-21

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', '..', 'helpers/chromosome.rb')
require File.join(File.dirname(__FILE__), '..', 'htga.rb')

# @author Cristhian Fuertes
# 
class HTGAKnapsack < HTGA
  
  # Method to initize attributes
  def initialize(**input)
    @pop_size = input[:pop_size]
    @cross_rate = input[:cross_rate]
    @mut_rate = input[:mut_rate]
    @num_genes = input[:num_genes]
    @upper_bounds = Array.new @num_genes, 1
    @lower_bounds = Array.new @num_genes, 0
    @chromosomes = []
    @knapsack_func = KNAPSACK_FUNCTION
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = input[:is_negative_fit]
    @max_generation = input[:max_generation]
    @values = input[:values]
    @weights = input[:weights]
    @max_weight = input[:max_weight]
    @optimal_func_val = input[:optimal_func_val]
    @num_evaluations = 0
  end
  
  # Main method
  # @return [Hash]
  def execute
    @generation = 0
    output_hash = {
                    best_fit: nil, gen_of_best_fit: 0, func_evals_of_best_fit: 0
                  }
    begin
      init_population
      p 'population initialized'
      update_output_hash output_hash
      select_taguchi_array
      p "the selected taguchi array is L#{@taguchi_array.size}"
      while @generation < @max_generation
        selected_indexes = roulette_select
        cross_individuals selected_indexes
        generate_offspring_by_taguchi_method
        mutate_individuals
        select_next_generation
        if @generation % 50 == 0
          p "Generation: #{@generation}- Fitness: #{@chromosomes.first.fitness}"
        end
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
    p output_hash
    output_hash
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
      @chromosomes << chromosome
    end
  end
  
  # Method to evaluate the fitness of a chromosome
  # @param [Chromosome] chromosome
  # @return void
  def evaluate_chromosome(chromosome)
    @num_evaluations += 1
    chromosome.fitness = @knapsack_func.call chromosome, @values, @weights, @max_weight
  end
  
  # Crossover operator method use in HTGA
  # @param [Chromosome] chromosome_x
  # @param [Chromosome] chromosome_y
  # @return [Chromosome, Chromosome]  the resulting crossovered chromosomes.
  def crossover(chromosome_x, chromosome_y)
    k = rand(0...chromosome_y.size)
    # swap right side of chromosomes x and y
    ((k + 1)...chromosome_y.size).each do |i|
      chromosome_x[i], chromosome_y[i] = chromosome_y[i], chromosome_x[i]
    end
    [chromosome_x, chromosome_y]
  end
  
  # Mutation operator method for the chromosomes
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @return [Chromosome] the resulting mutated chromosome
  def mutate(chromosome)
    gene_pos = ((0...@num_genes).to_a).sample
    gene = chromosome[gene_pos]
    if gene == 0 then gene = 1 else gene = 0 end
    chromosome[gene_pos] = gene
    chromosome 
  end
  
end

if __FILE__ == $PROGRAM_NAME
    # optimum 1130
    # htga = HTGAKnapsack.new pop_size: 200,
    #                         cross_rate: 0.1,
    #                         mut_rate: 0.02,
    #                         num_genes: 24,
    #                         is_negative_fit: false,
    #                         is_high_fit: true,
    #                         values: [150,200,60,60,30,70,15,40,75,20,50,1,35,160,45,40,10,30,10,70,80,12,10,150],
    #                         weights: [[9,153,15,27,23,11,24,73,43,7,4,90,13,50,68,39,52,32,48,42,22,18,30,200]],
    #                         max_weight: [500],
    #                         max_generation: 1000
    # p htga.execute
    
    
    # # optimum 3800
    #   weights = [[8, 12, 13, 64, 22, 41],
    #             [8, 12, 13, 75, 22, 41],
    #             [3, 6, 4, 18, 6, 4],
    #             [5, 10, 8, 32, 6, 12],
    #             [5, 13, 8, 42, 6, 20],
    #             [5, 13, 8, 48, 6, 20],
    #             [0, 0, 0, 0, 8, 0],
    #             [3, 0, 4, 0, 8, 0],
    #             [3, 2, 4, 0, 8, 4],
    #             [3, 2, 4, 8, 8, 4]]
    
    #   htga = HTGAKnapsack.new pop_size: 200,
    #                         cross_rate: 0.1,
    #                         mut_rate: 0.02,
    #                         num_genes: 6,
    #                         is_negative_fit: false,
    #                         is_high_fit: true,
    #                         values: [100, 600, 1200, 2400, 500, 2000],
    #                         weights: weights,
    #                         max_weight: [80, 96, 20, 36, 44, 48, 10, 18, 22, 24],
    #                         max_generation: 1000
    # p htga.execute
    
    
      # optimum 6120
      weights = [ 
                  [8, 24, 13, 80, 70, 80, 45, 15, 28, 90, 130, 32, 20, 120, 40,30, 20, 6, 3, 180],
                  [8, 44, 13, 100, 100, 90, 75, 25, 28, 120, 130, 32, 40, 160, 40, 60, 55, 10, 6, 240],
                  [3, 6, 4, 20, 20, 30, 8, 3, 12, 14, 40, 6, 3, 20, 5, 0, 5, 3, 0, 20],
                  [5, 9, 6, 40, 30, 40, 16, 5, 18, 24, 60, 16, 11, 30, 25, 10, 13, 5, 1, 80],
                  [5, 11, 7, 50, 40, 40, 19, 7, 18, 29, 70, 21, 17, 30, 25, 15, 25, 5, 1, 100],
                  [5, 11, 7, 55, 40, 40, 21, 9, 18, 29, 70, 21, 17, 35, 25, 20, 25, 5, 2, 110],
                  [0, 0, 1, 10, 4, 10, 0, 6, 0, 6, 32, 3, 0, 70, 10, 0, 0, 0, 0, 0],
                  [3, 4, 5, 20, 14, 20, 6, 12, 10, 18, 42, 9, 12, 100, 20, 5, 6, 4, 1, 20],
                  [3, 6, 9, 30, 29, 20, 12, 12, 10, 30, 42, 18, 18, 110, 20, 15, 18, 7, 2, 40],
                  [3, 8, 9, 35, 29, 20, 16, 15, 10, 30, 42, 20, 18, 120, 20, 20, 22, 7, 3, 50]
                ]

      htga = HTGAKnapsack.new pop_size: 200,
                            cross_rate: 0.1,
                            mut_rate: 0.02,
                            num_genes: 20,
                            is_negative_fit: false,
                            is_high_fit: true,
                            values: [100, 220, 90, 400, 300, 400, 205, 120, 160, 580, 400, 140, 100, 1300, 650, 320, 480, 80, 60, 2550],
                            weights: weights,
                            max_weight: [550, 700, 130, 240, 280, 310, 110, 205, 260, 275],
                            max_generation: 1000
      p htga.execute
end