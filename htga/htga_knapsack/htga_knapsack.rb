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
        @generation += 1
      end
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
      exit
    end
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
    # chromosome = correct_chromosome chromosome
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
    # htga = HTGAKnapsack.new pop_size: 200,
    #                         cross_rate: 0.1,
    #                         mut_rate: 0.02,
    #                         num_genes: 24,
    #                         is_negative_fit: false,
    #                         is_high_fit: true,
    #                         values: [150,200,60,60,30,70,15,40,75,20,50,1,35,160,45,40,10,30,10,70,80,12,10,150],
    #                         weights: [9,153,15,27,23,11,24,73,43,7,4,90,13,50,68,39,52,32,48,42,22,18,30,200],
    #                         max_weight: 500,
    #                         max_generation: 1000
    # p htga.execute
    
      htga = HTGAKnapsack.new pop_size: 200,
                             cross_rate: 0.1,
                             mut_rate: 0.02,
                             num_genes: 6,
                             is_negative_fit: false,
                             is_high_fit: true,
                             values: [100, 600, 1200, 2400, 500, 2000],
                             weights: [8, 12, 13, 64, 22, 41],
                             max_weight: 80,
                             max_generation: 1000
    p htga.execute
  end