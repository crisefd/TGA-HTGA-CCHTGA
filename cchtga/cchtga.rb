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
require File.join(File.dirname(__FILE__), '..', 'helpers/subsystem.rb')

# @author Cristhian Fuertes
# Main class for the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm
class CCHTGA < HTGA
  # @!attribute [Chromosome] the current chromosome with the best fitness
  attr_reader :best_chromosome
  # @!attribute [Chromosome] the current chromosome with the best fitness
  attr_reader :prev_best_chromosome
  # @!attribute [Array<Chromsome>] list with the best experience of the
  # chromosomes
  attr_reader :best_chromosomes_experiences

  def initialize(**input)
    super input
    @best_chromosome = nil
    @prev_best_chromosome = nil
    @best_chromosomes_experiences = []
  end

  # Method to calculate a list of divisors for n = number of variables
  # @return [Array<Integer>]
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

  # Method to divide the variables in K subsystems
  # @note A random value s in chosen from the a list of divisor
  # (see #calculate_divisors), then K = n / s. Where n is the number of
  # variables
  def divide_variables
    divisors = calculate_divisors
    s = divisors.sample
    k = @num_genes / s
    @subsystems = Array.new(k) { Subsystem.new }
  end

  # Method to perform random grouping
  # @return [void]
  def random_grouping
    (0...@num_genes).each do |g|
      j = rand(0...@subsystems.size)
      @subsystems[j] << g
    end
  end


  # Method to perfom SNR calculation used in the CCHTGA
  # @param [Chromosome] chromosome, the chromosome
  # @return [void]
  def calculate_snr(chromosome, subsystem)
    if @is_high_fit
      fail "CCHTGA's SNR calculation for maximization not implemented yet"
    else
      evaluate_chromosome chromosome # Wrong
      # What if the rest equals zero ?
      chromosome.snr = (chromosome.fitness - @best_chromosome.fitness)**-2
    end
  end

  # Mutation operator method for the chromosomes
  # @param [Subystem] subsystem
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @param [Integer] position
  # @return [Chromosome]
  def mutate(subsystem, chromosome, position)
    best_experience = @best_chromosomes_experiences[position]
    subsystem.each do |i|
      p = rand(0..10) / 10.0 # correct ?
      r = rand(0..10) / 10.0
      if p < 0.5
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
  # @param [Subystem] subsystem
  # @return [void]
  def mutate_individuals(subsystem)
    m = @chromosomes.size
    (0...m).each do |j|
      r = rand(0.0..1.0)
      next if r > @mut_rate
      new_chrom = mutate subsystem, @chromosomes[x].clone, x
      evaluate_chromosome new_chrom
      @chromosomes << new_chrom
    end
  end

  # Crossover operator method use in CCHTGA
  # @param [Subsystem] subsystem
  # @param [Chromosome] chromosome_x
  # @param [Chromosome] chromosome_y
  # @return [Chromosome, Chromosome]  the resulting crossovered chromosomes.
  def crossover(subsystem, chromosome_x, chromosome_y)
    beta = rand(0..10) / 10.0
    k = subsystem.to_a.sample
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
    subsystem.each do |i|
      if i > k
        chromosome_x[i], chromosome_y[i] = chromosome_y[i], chromosome_x[i]
      end
    end
    [chromosome_x, chromosome_y]
  end

  # Method to perform crossover operation over chromosomes
  # @param [Integer] offset for the selected chromosomes by the #roulette_select
  # method
  # @return [void]
  def cross_individuals(subsystem, selected_offset)
    m = selected_offset
    m += 1 if m == 1
    (0...m).each do |x|
      r = rand(0.0..1.0)
      y = -1
      loop do
        y = rand(0...m)
        break if x != y
      end
      next if r > @cross_rate
      new_chrom_x, new_chrom_y = crossover subsystem, @chromosomes[x].clone,
                                           @chromosomes[y].clone

      evaluate_chromosome new_chrom_x
      evaluate_chromosome new_chrom_y
      @chromosomes << new_chrom_x << new_chrom_y
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
          beta = rand(0.0..1.0)
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
      @best_chromosomes_experiences << chromosome
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
      'implement...'
    end
  end
end
