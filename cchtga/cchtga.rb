# language: english
# encoding: utf-8
# Program: cchtga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-04-02

require 'rubygems'
require 'bundler/setup'
# require File.join(File.dirname(__FILE__), '..', 'htga/htga.rb')
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/subsystem.rb')

# @author Cristhian Fuertes
# Main class for the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm
class CCHTGA < BaseGA
  
  attr_reader :best_chromosome
  attr_reader :prev_best_chromosome
  attr_reader :subsystems
  attr_writer :num_genes

  def initialize(**input)
    super input
    @best_chromosome = nil
    @prev_best_chromosome = nil
  end

# Method to calculate a list of divisors for n = number of variables
# @return [Array<Integer>]
def calculate_divisors
  divisors = []
  flags = Array.new(@num_genes) { false }
  m = Math.sqrt(@num_genes)
  (2..m).each do |i|
    if @num_genes % i == 0
      unless flags[i]
        divisors << i
        flags[i] = true
      end
      if i != (@num_genes / i) && 0 != (@num_genes / i) &&
         1 != (@num_genes / i) && !flags[@num_genes / i]
        divisors << @num_genes / i
        flags[@num_genes / i] = true
      end
    end
  end
  divisors
end


  # Method to divide the variables in K subsystems
  # @note A random value s in chosen from the a list of divisor
  # (see #calculate_divisors), then K = n / s. Where n is the number of
  # variables
  def divide_variables
    divisors = calculate_divisors
    s = divisors.sample
    @genes_per_group = s
    k = @num_genes / s
    @subsystems = Array.new(k) { Subsystem.new }
  end

  # Method to perform random grouping
  # @return [void]
  def random_grouping
    available_genes = (0...@num_genes).to_a
    (0...@subsystems.size).each do |j|
      (0...@genes_per_group).each do
        g = available_genes.delete_at(rand(available_genes.size))
        @subsystems[j] << g
      end
    end
  end


  # Method to correct genes in case a chromosome exceeds the bounds
  # @param [Chromosome] chromosome
  # @note The search space is doubled in each dimension and reconnected
  # from the opposite bounds to avoid discontinuities
  def correct_genes(chromosome)
    i = 0
    chromosome.map! do |gene|
      if gene < @lower_bounds[i]
        gene = 2 * @lower_bounds[i] - gene
      elsif @upper_bounds[i] < gene
        gene = 2 * @upper_bounds[i] - gene
      end
      i += 1
      gene
    end
  end

  # Method to generate the initial population of chromosomes
  # @return [void]
  # @note It also initialize the best experiences for chromosomes and the best
  # chromosome
  def init_population
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        if @beta_values == 'discrete'
          beta = rand(0..10) / 10.0
        elsif @beta_values == 'uniform distribution'
          beta = rand 0.0..1.0
        end
        gene = @lower_bounds[i] + beta * (@upper_bounds[i] -
                                                 @lower_bounds[i])
        if @continuous # Wrong for discrete functions
          chromosome << gene
        else
          chromosome << gene.floor
        end
      end
      evaluate_chromosome chromosome
      @chromosomes << chromosome
      if @is_high_fit
        @best_chromosome = chromosome.clone if @best_chromosome.nil? ||
                                               chromosome.fitness >
                                               @best_chromosome.fitness
      else
        @best_chromosome = chromosome.clone if @best_chromosome.nil? ||
                                               chromosome.fitness <
                                               @best_chromosome.fitness
      end
    end
  end

  def apply_htga_to_subsystems
    @subsystems.each do |subsystem|
      sub_chromosomes, lower_bounds, upper_bounds = decompose_chromosomes subsystem
      ihtga = IHTGA.new chromosomes: sub_chromosomes,
                        lower_bounds: lower_bounds,
                        upper_bounds: upper_bounds,
                        beta_values: @beta_values,
                        pop_size: @pop_size,
                        cross_rate: @cross_rate,
                        mut_rate: @mut_rate,
                        continuous: @continuous,
                        selected_func: @selected_func,
                        is_negative_fit: @is_negative_fit,
                        is_high_fit: @is_high_fit,
                        subsystem: subsystem,
                        mutation_prob: 0.5
      ihtga.execute
    end
  end
  
  def decompose_chromosomes(subystem)
    sub_chromosomes = []
    lower_bounds = []
    upper_bounds = []
    @chromosomes.each do |chromosome|
      sub_chromosome = Chromosome.new
      subsystem.each do |g|
        sub_chromosome << chromosome[g]
        lower_bounds << @lower_bounds[g]
        upper_bounds << @upper_bounds[g]
      end
      sub_chromosomes << sub_chromosome
    end
    [sub_chromosomes, upper_bounds, lower_bounds]
  end
end
