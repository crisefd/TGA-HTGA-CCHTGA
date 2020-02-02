# frozen_string_literal: true

# language: en
# program: ihtga.rb
# creation date: 2016-05-18
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'htga/htga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# Main class for the Improved Hybrid-Taguchi Genetic Algorithm
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class IHTGA < HTGA
  # @!attribute [w] best_chromosome
  #  @return [Chromosome] the best chromosome
  attr_writer :best_chromosome
  # @!attribute subsystem
  #  @return [Subsystem] The subsystem
  attr_accessor :subsystem
  # @!attribute [w] selected_func
  #  @return [Proc] The function object
  attr_writer :selected_func

  # @param [Hash] input The input values for the algorithm
  # @option input [String] :beta_values The type of random numbers
  # (discrete | uniform distribution) to be use in {#init_population}
  # @option input [Array] :upper_bounds The upper bounds for the grouped genes
  # @option input [Array] :lower_bounds The lower bounds for the grouped genes
  # @option input [Integer] :pop_size The number of chromosomes the population
  # @option input [Float] :cross_rate The crossover rate
  # @option input [Float] :mut_rate The mutation rate
  # @option input [Integer] :num_genes The number of genes in a chromosome
  # @option input [Boolean] :continuous Flag to indicate
  # if the problem being solved is continuous or discrete
  # @option input [Integer] :selected_function
  # The number of the test function (f1, f2,...,f15) to solved
  # @option input [Boolean] :is_high_fit
  # Flag to indicate if the problem to be resolved is
  # a maximization or minimization problem
  # @option input [Float] :optimal_func_val
  # The best known value for the problem being solved
  # @option input [Integer] :max_generation The max number of generations
  # @option input [Float] :mutation_prob The probabily of a gene to be mutated
  # @option input [Subsystem] :subsystem The subsystem
  # @option input [Array<Chromosomes>] :chromosomes
  # Population of chromosomes with grouped genes
  def initialize(**input)
    @beta_values = input[:beta_values]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @pop_size = input[:pop_size]
    @cross_rate = input[:cross_rate]
    @mut_rate = input[:mut_rate]
    @chromosomes = input[:chromosomes]
    @continuous = input[:continuous]
    input[:selected_func] = 0 if input[:selected_func].nil?
    @selected_func = input[:selected_func]
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
    @best_chromosome = nil
    @subsystem = input[:subsystem]
    @num_genes = @subsystem.size
    @subsystem.best_chromosomes_experiences = input[:chromosomes]
    @mutation_prob = input[:mutation_prob]
    @taguchi_array = input[:taguchi_array]
    @num_evaluations = 0
    @subsystem.chromosomes = @chromosomes
  end

  # Main method
  # @return [nil]
  def execute
    find_best_chromosome
    cross_inviduals
    generate_offspring_by_taguchi_method
    mutate_individuals
    @chromosomes = sus_select
    @subsystem.chromosomes = @chromosomes
    @subsystem.num_evaluations = @num_evaluations
  end

  # Finds the current generation's best chromosome
  # @return [nil]
  def find_best_chromosome
    @chromosomes.map! do |chromo|
      evaluate_chromosome chromo
      compare_func = @is_high_fit ? :> : :<
      if @best_chromosome.nil? ||
         chromo.fitness.public_send(compare_func, @best_chromosome.fitness)
        @best_chromosome = chromo.clone
      end
      chromo
    end
    @subsystem.best_chromosome = @best_chromosome
  end

  # It recursively corrects a gene that is outside its bounds
  # @param [Float] gene The gene to be corrected
  # @param [Float] lower_bound The lower bound of the gene
  # @param [Float] upper_bound The upper bound of the gene
  # @return [Float] The corrected gene
  # @note The search space is doubled in each dimension and
  # reconected from the opposite bounds to avoid discontinuities
  def correct_gene(gene, lower_bound, upper_bound)
    corrected_gene = nil
    if gene >= lower_bound && gene <= upper_bound
      corrected_gene = gene
    elsif gene < lower_bound
      gene = 2 * lower_bound - gene
      corrected_gene = correct_gene gene, lower_bound, upper_bound
    elsif upper_bound < gene
      gene = 2 * upper_bound - gene
      corrected_gene = correct_gene gene, lower_bound, upper_bound
    end
    corrected_gene
  end

  # Mutation operator
  # @param [Chromosome] chromosome parent chromosome
  # @param [Integer] position the position of the chromosome in the population
  # @return [Chromosome] The mutated chromosome
  def mutate(chromosome, position)
    best_experience = @subsystem.best_chromosomes_experiences[position]
    (0...@num_genes).each do |i|
      p = rand(0..10) / 10.0
      r = rand(0..10) / 10.0
      gene = if p < @mutation_prob
               @lower_bounds[i] + r * (@upper_bounds[i] -
                                              @lower_bounds[i])
             else
               chromosome[i] + (2 * r - 1) * (@best_chromosome[i] -
                                                     best_experience[i]).abs
             end
      chromosome[i] = correct_gene gene, @lower_bounds[i], @upper_bounds[i]
    end
    chromosome
  end

  # Mutates the chromosomes
  # @return [nil]
  def mutate_individuals
    m = @pop_size
    (0...m).each do |x|
      r = rand 0.0..1.0
      next if r > @mut_rate
      new_chrom = mutate(@chromosomes[x].clone, x)
      evaluate_chromosome new_chrom
      @chromosomes << new_chrom
    end
  end

  # Crossover operator
  # @param [Chromosome] chromosome_x First parent chromosome
  # @param [Chromosome] chromosome_y Second parent chromosome
  # @return [Array<Chromosome>] the resulting crossovered chromosomes.
  def crossover(chromosome_x, chromosome_y)
    beta = rand(0..10) / 10.0
    k = rand(0...chromosome_y.size)
    # new values for kth genes x and y
    cut_point_x = chromosome_x[k]
    cut_point_y = chromosome_y[k]
    cut_point_x += beta * (cut_point_y - cut_point_x)
    cut_point_y = lower_bounds[k] + beta * (@upper_bounds[k] - @lower_bounds[k])
    if @continuous # Doesn't work with discrete functions
      chromosome_x[k] = cut_point_x
      chromosome_y[k] = cut_point_y
    else
      chromosome_x[k] = cut_point_x.floor
      chromosome_y[k] = cut_point_y.floor
    end
    # swap right side of chromosomes x and y
    ((k + 1)...chromosome_y.size).each do |i|
      chromosome_x[i], chromosome_y[i] = chromosome_y[i], chromosome_x[i]
    end
    [chromosome_x, chromosome_y]
  end

  # Crosses the chromosomes
  # @return [nil]
  def cross_inviduals
    m = @chromosomes.size
    (0...m).each do |x|
      r = rand 0.0..1.0
      y = -1
      loop do
        y = rand 0...m
        break if x != y
      end
      next if r > @cross_rate
      new_chrom_x, new_chrom_y =
        crossover @chromosomes[x].clone, @chromosomes[y].clone
      evaluate_chromosome new_chrom_x
      evaluate_chromosome new_chrom_y
      @chromosomes << new_chrom_x << new_chrom_y
    end
  end

  # Perfoms SNR calculation
  # @param [Chromosome] chromosome The chromosome at which its SNR value is calculated
  # @return [nil]
  def calculate_snr(chromosome)
    raise "CCHTGA's SNR calculation for maximization not implemented yet" if @is_high_fit
    evaluate_chromosome chromosome
    # What if the rest equals zero ?
    chromosome.snr = (chromosome.fitness - @best_chromosome.fitness)**-2
  end
end
