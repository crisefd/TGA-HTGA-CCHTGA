# language: english
# encoding: utf-8
# Program: cchtga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-04-02

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'htga/htga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# @author Cristhian Fuertes
# Main class for the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm
class CCHTGA < HTGA
  # @!attribute [Chromosome] the current chromosome with the best fitness
  attr_reader :best_chromosome
  # @!attribute [Array<Chromsome>] list with the best experience of the
  # chromosomes
  attr_reader :best_chromosomes_experiences

  # @param [Hash] input, hash list for the initialization of the HTGA
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
    p "HTGA is_negative_fit #{@is_negative_fit}"
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
    @num_evaluations = 0
  end

  def calculate_divisors
    divisors = []
    n = Math.sqrt(@num_genes).round
    (2..n).each do |i|
      if i % @num_genes == 0
        divisors << i
        divisors << n / i if i != n / i
      end
    end
    divisors
  end

  def divide_variables
    divisors = calculate_divisors
    s = divisors.sample
    num_subsystems = @num_genes / s
    @subsystems = Array.new(num_subsystems) { [] }
  end

  def random_grouping
    (0...@num_genes).each do |g|
      j = rand(0...@subsystems.size)
      @subsystems[j] << g
    end
  end

  # Method to perfom SNR calculation used in the CCHTGA
  # @param [Chromosome] chromosome, the chromosome
  # @return [void]
  def calculate_snr(chromosome)
    if @is_high_fit
      fail "CCHTGA's SNR calculation for maximization not implemented yet"
    else
      evaluate_chromosome chromosome
      chromosome.snr = (chromosome.fitness - @best_chromosome.fitness)**-2
    end
  end

  # Mutation operator method for the chromosomes
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @return [Chromosome] the resulting mutated chromosome
  def mutate(chromosome, position)
    best_experience = @best_chromosomes_experiences[position]
    (0...@num_genes).each do |i|
      p = rand(0..10) / 10.0 # correct ?
      r = rand(0..10) / 10.0
      if p < 0.5 # Where to apply the correction ?
        chromosome[i] = @lower_bounds[i] + r * (@upper_bounds[i] -
                                                @lower_bounds[i])
      else
        chromosome[i] = chromosome[i] + (2 * r - 1) * (@best_chromosome[i] -
                                                       best_experience[i]).abs
      end
    end
    chromosome
  end

  # Method to perform mutation operation over the chromosomes
  # @return [void]
  def mutate_individuals
    m = @chromosomes.size
    (0...m).each do
      r = rand(0.0..1.0)
      next if r > @mut_rate
      x = rand(0...m)
      new_chrom = mutate @chromosomes[x].clone, x
      evaluate_chromosome new_chrom
      @chromosomes << new_chrom
    end
  end

  # Method to correct genes in case a chromosome exceeds the bounds
  # @param [Integer] gene, the ith gene
  # @param [Integer] u, the ith upper bound
  # @param [Integer] l, the ith lower bound
  # @return [Integer]
  # @note The search space is doubled in each dimension and reconnected
  # from the opposite bounds to avoid discontinuities
  def correct_gene(gene, u, l)
    if gene < l
      gene = 2 * l - gene
    elsif u < gene
      gene = 2 * u - gene
    end
    gene
  end
end
