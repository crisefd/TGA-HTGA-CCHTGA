# language: english
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')

# Dir[File.dirname(__FILE__) + './../base_ga/*.rb'].each do |file|
# require File.basename(file, File.extname(file))
# end

# require '/home/crisefd/Ruby/TGA-HTGA-CCHTGA/base_ga/base_ga'

# @author Cristhian Fuertes
# Main class for the Hybrid-Taguchi Genetic Algorithm
class HTGA < BaseGA
  attr_accessor :taguchi_array

  # @param [Hash] input, hash list for the initialization of the HTGA
  def initialize(**input)
    @values = input[:values]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @pop_size = input[:pop_size]
    @cross_rate = input[:cross_rate]
    @mut_rate = input[:mut_rate]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuous = input[:continuous]
    @selected_func = input[:selected_func]
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
  end

  # Main method for the HTGA
  def execute
  end

  # Crossover operation method use in HTGA
  # @param [Hash] args, argument hash list that includes chromosomes, lower and upper bounds
  # @return [Chromosome, Chromosome]  the resulting chromosomes.
  def self.crossover(**args)
    chromosome_x = args[:chromosome_x]
    chromosome_y = args[:chromosome_y]
    beta = rand(0..10) / 10.0
    k = rand(0...chromosome_y.size)
    upper_bounds = args[:upper_bounds]
    lower_bounds = args[:lower_bounds]
    # new values for kth genes x and y
    cut_point_x = chromosome_x[k]
    cut_point_y = chromosome_y[k]
    cut_point_x = cut_point_x + beta * (cut_point_y - cut_point_x)
    cut_point_y = lower_bounds[k] + beta * (upper_bounds[k] - lower_bounds[k])
    chromosome_x[k] = cut_point_x
    chromosome_y[k] = cut_point_y
    # swap right side of chromosomes x and y
    ((k + 1)...chromosome_y.size).each do |i|
      chromosome_x[i], chromosome_y[i] = chromosome_y[i], chromosome_x[i]
    end
    return chromosome_x, chromosome_y
  end

  # Mutation operation method for the chromosomes
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @return [Chromosome] the resulting chrmosome
  def self.mutate(chromosome)
    beta = rand(0..10) / 10.0
    i = -1
    k = -1
    loop do
      i = rand(0...chromosome.size)
      k = rand(0...chromosome.size)
      break if i != k
    end
    gene_i = chromosome[i]
    gene_k = chromosome[k]
    chromosome[i] = (1 - beta) * gene_i + beta * gene_k
    chromosome[k] = beta * gene_i + (1 - beta) * gene_k
    chromosome
  end

  # Method to perfom SNR calculation used in the HTGA
  # @param [Chromosome] chromosome, the chromosome
  # @param [Boolean] smaller_the_better, true if SNR is for minization or false otherwise
  # @return [Float] the calculated SNR
  def self.calculate_snr(chromosome, smaller_the_better: true)
    n = chromosome.size
    if smaller_the_better
      chromosome.snr = -10 * Math.log10((1.0 / n) * chromosome.map { |gene| gene**2 }.reduce(:+))
    else
      chromosome.snr = -10 * Math.log10((1.0 / n) * chromosome.map { |gene| 1.0 / gene**2 }.reduce(:+))
    end
  end

  # Method to perform cross over operation over chromosomes
  # @return [void]
  def cross_individuals
    m = @pop_size
    (0...m).each do
      r = @ran.rand(1.0)
      next if r > @cross_rate
      loop do
        x = rand(0...@pop_size)
        y = rand(0...@pop_size)
        next if x == y
        new_chrom_x, new_chrom_y =
                       HTGA.crossover(chromosome_x: @chromosomes[x].clone,
                                      chromosome_y: @chromosomes[y].clone,
                                      upper_bounds: @upper_bounds,
                                      lower_bounds: @lower_bounds)
        @chromosomes << new_chrom_x << new_chrom_y
        break
      end
    end
  end

  # Method to perform mutation operation over the chromosomes
  # @return [void]
  def mutate_individuals
    m = @chromosomes.size
    (0...m).each do
      r = @ran.rand(1.0)
      next if r > @mut_rate
      x = rand(0...m)
      new_chrom = Chromosome.mutate(@chromosomes[x].clone)
      @chromosomes << new_chrom
    end
  end

  # Method that select the best M chromosomes for the next generation
  # @return [void]
  def select_next_generation
    # sort in decreasing order of fitness values
    @chromosomes.sort! do |left_chrom, right_chrom|
      right_chrom.fitness <=> left_chrom.fitness
    end
    @chromosomes.slice!(@pop_size..@chromosomes.size)
  end

  # Method that selects the most suitable Taguchi array
  # @param [Integer] chrom_size, the number of variables of the function
  def select_taguchi_array(chrom_size)
    closest = 0
    [8, 16, 32, 64, 128].each do |n|
      if chrom_size <= n - 1
        closest = n
        break
      end
    end
    file_name = "L#{closest}"
    load_array_from_file file_name, chrom_size
  end

  # Auxiliar method for #select_taguchi_array, it loads the array from a file
  # @param [String] filename, the name of the file which contains the array
  # @param [Integer] chrom_size, the number of variables of the function
  def load_array_from_file(filename, chrom_size)
    @taguchi_array = []
    path_to_file = File.join(File.dirname(__FILE__), '..',
                             "taguchi_orthogonal_arrays/#{filename}")
    array_file = open(path_to_file, 'r')
    array_file.each_line do |line|
      @taguchi_array << line.split(';')[0, chrom_size]
    end
    array_file.close
  end

  def generate_optimal_chromosome(chromosome_x, chromosome_y)
    experimental_matrix = generate_experimental_matrix chromosome_x,
                                                       chromosome_y

  end

  def generate_experimental_matrix(chromosome_x, chromosome_y)
    experimental_matrix = []
    (0...@taguchi_array.size).each do |i|
      row_chromosome = Chromosome.new
      (0...@taguchi_array[0].size).each do |j|
        if @taguchi_array[i][j] == 0
          row_chromosome << chromosome_x[j]
        else
          row_chromosome << chromosome_y[j]
        end
        @taguchi_array << row_chromosome
      end
    end
    experimental_matrix
  end


  # Method to generate the initial population of chromosomes
  # @return [void]
  def init_population
    @ran = Random.new
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        if @values == 'discrete'
          beta = (Array.new(11) { |k| k / 10.0 }).sample
        elsif @values == 'uniform distribution'
          beta = @ran.rand(1.0)
        end
        gene = @lower_bounds[i] + beta * (@upper_bounds[i] -
                                                 @lower_bounds[i])
        if @continuous
          chromosome << gene
        else
          chromosome << gene.round
        end
      end
      chromosome.fitness = TEST_FUNCTIONS[@selected_func].call chromosome
      @chromosomes << chromosome
    end
  end
end

if __FILE__ == $PROGRAM_NAME
=begin
   htga = HTGA.new(selected_func: 0, values: 'uniform distribution',
                 continuous: true, pop_size: 5, num_genes: 5,
                  upper_bounds: [5,5,5,5,5], lower_bounds: [-5, -5, -5, -5, -5])
  htga.init_population
=end
end
