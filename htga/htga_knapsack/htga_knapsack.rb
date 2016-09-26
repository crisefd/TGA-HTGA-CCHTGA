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
          p "Generation: #{@generation}- Fitness: #{@chromosomes.first.fitness} -- Weight: #{@chromosomes.first.weight}"
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
  
  def init_population
     (0...@pop_size).each do
      chromosome = Chromosome.new
      # chromosome.ones_positions = []
      (0...@num_genes).each do |i|
        gene = rand 0..1
        # chromosome.ones_positions << i if gene == 1
        chromosome << gene
      end
      chromosome = evaluate_chromosome chromosome
      # p chromosome.fitness
      @chromosomes << chromosome
    end
  end
  
  
    def correct_chromosome(chromosome)
      corrected_chromosome = chromosome.clone
      ones_positions = chromosome.ones_positions.clone
      num_available_ones = ones_positions.size
      num_chosen_ones = 0
      list_unchosen_ones = ones_positions.clone
      list_chosen_ones = []
      weight_sum = 0
      range = (0...num_available_ones).to_a
      # p "max_weight #{@max_weight}"
      # p "weights #{@weights}"
      # p "range #{range}"
      # p "ones #{ list_unchosen_ones}"
       while range.size > 0 do
         # p "num_available_ones #{num_available_ones}"
         # p "num_chosen_ones #{num_chosen_ones}"
          j = range.delete_at(rand(range.size))
          i = ones_positions[j]
          fail "ones_positions: #{ones_positions} #{ones_positions.size}" if i >= @weights.size
        #  p "i=#{i} j=#{j}"
          if weight_sum + @weights[i] < @max_weight
         #   p "0)  weight_sum = #{weight_sum} weights[i] = #{@weights[i]}"
            weight_sum += @weights[i]
            num_chosen_ones += 1
            num_available_ones -= 1
            list_unchosen_ones.delete(j)
            list_chosen_ones << j
          #  p "ones #{ list_unchosen_ones}"
          elsif weight_sum + @weights[i] == @max_weight
           # p "1)  weight_sum = #{weight_sum} weights[i] = #{@weights[i]}"
            num_chosen_ones += 1
            num_available_ones -= 1
            weight_sum += @weights[i]
            list_unchosen_ones.delete(j)
            list_chosen_ones << j
            list_unchosen_ones.each do |k|
              corrected_chromosome[k] = 0
            end
            corrected_chromosome[i] = 1
            # p "ones #{ list_unchosen_ones}"
            break
          else
            # p "2)  weight_sum = #{weight_sum} weights[i] = #{@weights[i]}"
            corrected_chromosome[i] = 0
            list_unchosen_ones.delete(j)
            # p "ones #{ list_unchosen_ones}"
            next if weight_sum < @max_weight
            list_unchosen_ones.each do |k|
              corrected_chromosome[k] = 0
            end
            break
          end
      end
      corrected_chromosome.ones_positions = list_chosen_ones
      corrected_chromosome.weight = weight_sum
      # p "ones #{ list_chosen_ones}"
      # p "=================="
      # p "corrected_chromosome: #{corrected_chromosome}"
      # p "ones pos: #{corrected_chromosome.ones_positions}"
      return corrected_chromosome
    
  end
  
  def evaluate_chromosome(chromosome)
    chromosome = correct_chromosome chromosome
    @num_evaluations += 1
    chromosome.fitness = @knapsack_func.call chromosome, @values
    chromosome
  end
  
  # Crossover operator method use in HTGA
  # @param [Chromosome] chromosome_x
  # @param [Chromosome] chromosome_y
  # @return [Chromosome, Chromosome]  the resulting crossovered chromosomes.
  def crossover(chromosome_x, chromosome_y)
    beta = rand(0..10) / 10.0
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
  
  # Method to perform crossover operation over chromosomes
  # @param [Integer] offset for the selected chromosomes by the #roulette_select
  # method
  # @return [void]
  def cross_individuals(selected_indexes, select_method: :roulette)
    if select_method == :roulette
      m = selected_indexes.size
      (0...m).each do
        x = selected_indexes.sample
        y = selected_indexes.sample
        new_chrom_x, new_chrom_y =
        crossover @chromosomes[x].clone, @chromosomes[y].clone

        new_chromo_x = evaluate_chromosome new_chrom_x
        new_chromo_y = evaluate_chromosome new_chrom_y
        @chromosomes << new_chrom_x << new_chrom_y
      end
    elsif select_method == :tournament
      m = selected_indexes.size - 1
      (0...m).each do |j|
        x = selected_indexes.sample
        y = selected_indexes.sample
        new_chrom_x, new_chrom_y =
        crossover @chromosomes[x].clone, @chromosomes[y].clone
        new_chrom_x = evaluate_chromosome new_chrom_x
        new_chrom_y = evaluate_chromosome new_chrom_y
      end
    end
  end
  
   # Method to generate the optimal crossovered chromosome
  # @param [Chromosome] chromosome_x, the first chromosome
  # @param [Chromosome] chromosome_y, the second chromosome
  # @return [Chromosome] the optimal chromosome
  def generate_optimal_chromosome(chromosome_x, chromosome_y)
    optimal_chromosome = Chromosome.new
    experiment_matrix = generate_experiment_matrix chromosome_x, chromosome_y
    # Calculate SNR values
    experiment_matrix.each_index do |i|
      calculate_snr experiment_matrix[i]
    end
    # Calculate the effects of the various factors
    (0...experiment_matrix[0].size).each do |j|
      sum_lvl_1 = 0.0
      sum_lvl_2 = 0.0
      (0...experiment_matrix.size).each do |i|
        if @taguchi_array[i][j] == 1
          sum_lvl_2 += experiment_matrix[i].snr
        else
          sum_lvl_1 += experiment_matrix[i].snr
        end
      end
      if sum_lvl_1 > sum_lvl_2
        optimal_chromosome << chromosome_x[j]
      else
        optimal_chromosome << chromosome_y[j]
      end
    end
    # Find the optimal fitness value
    optimal_chromosome = evaluate_chromosome optimal_chromosome
    # Return the optimal chromosome
    optimal_chromosome
  end

  # Method to perform mutation operation over the chromosomes
  # @return [void]
  def mutate_individuals
    m = @chromosomes.size
    (0...m).each do |x|
      r = rand(0.0..1.0)
      next if r > @mut_rate
      new_chrom = mutate @chromosomes[x].clone
      new_chrom = evaluate_chromosome new_chrom
      @chromosomes << new_chrom
    end
  end
  
end

if __FILE__ == $PROGRAM_NAME
    htga = HTGAKnapsack.new pop_size: 200,
                             cross_rate: 0.1,
                             mut_rate: 0.02,
                             num_genes: 24,
                             is_negative_fit: false,
                             is_high_fit: true,
                             values: [150,200,60,60,30,70,15,40,75,20,50,1,35,160,45,40,10,30,10,70,80,12,10,150],
                             weights: [9,153,15,27,23,11,24,73,43,7,4,90,13,50,68,39,52,32,48,42,22,18,30,200],
                             max_weight: 500,
                             max_generation: 1000
    p htga.execute
  end