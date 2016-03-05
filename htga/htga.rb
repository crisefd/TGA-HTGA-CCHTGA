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
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

def pp(arg)
  # p arg
end

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
    input[:selected_func] = 0 if input[:selected_func].nil?
    @selected_func = TEST_FUNCTIONS[input[:selected_func] - 1]
    @optimal_func_val = OPTIMAL_FUNCTION_VALUES[input[:selected_func] - 1]
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
  end

  # Main method for the HTGA
  def execute
    @generation = 1
    best_fit = nil
    init_time = Time.now
    begin
      init_population
      p 'population initialized'
      select_taguchi_array
      p "the selected taguchi array is L#{@taguchi_array.size}"
      while @generation <= @max_generation
        selected_offset = roulette_select
        cross_individuals selected_offset
        generate_offspring_by_taguchi_method
        mutate_individuals
        recalculate_fitness
        select_next_generation
        p "GENERATION #{@generation} fitness #{@chromosomes.first.fitness}" if @generation % 10 == 0
        if @is_high_fit
          best_fit = @chromosomes.first.fitness if best_fit.nil? || @chromosomes.first.fitness > best_fit
        else
          best_fit = @chromosomes.first.fitness if best_fit.nil? || @chromosomes.first.fitness < best_fit
        end
        break if @chromosomes.first.fitness == @optimal_func_val
        @generation += 1
      end
      p '==================OUTPUT===================='
      p "generations #{@generation}"
      p "first chromosome of last gen #{@chromosomes[0]}"
      p "first fitness of last gen #{@chromosomes[0].fitness}"
      p "best fitness #{best_fit}"
      p "function calls #{@pop_size + 0.5 * @pop_size * @cross_rate * (@taguchi_array.size + 2) * @generation}"
      p "Execution time (seconds): #{Time.now - init_time}"
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
      exit
    end
  end

  # Crossover operator method use in HTGA
  # @param [Hash] args, argument hash list that includes chromosomes, lower and upper bounds
  # @return [Chromosome, Chromosome]  the resulting chromosomes.
  def self.crossover(**args)
    continuous = args[:continuous]
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
    if continuous
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
    return chromosome_x, chromosome_y
  end

  # Mutation operator method for the chromosomes
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @return [Chromosome] the resulting chrmosome
  def self.mutate(chromosome, continuous: true) # Does not work for discrete functions
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
    if continuous
      chromosome[i] = (1 - beta) * gene_i + beta * gene_k
      chromosome[k] = beta * gene_i + (1 - beta) * gene_k
    else
      chromosome[i] = ((1 - beta) * gene_i + beta * gene_k).floor
      chromosome[k] = (beta * gene_i + (1 - beta) * gene_k).floor
    end
    chromosome
  end

  # Method to perfom SNR calculation used in the HTGA
  # @param [Chromosome] chromosome, the chromosome
  # @param [Boolean] smaller_the_better, true if SNR is for minization or false otherwise
  # @return [void]
  def self.calculate_snr(chromosome, smaller_the_better: true)
    n = chromosome.size.to_f
    if smaller_the_better
      chromosome.snr = -10.0 * Math.log10((1.0 / n) * chromosome.map { |gene| gene**2.0 }.reduce(:+))
    else # What happens when the gene is 0 ?
      chromosome.snr = -10.0 * Math.log10((1.0 / n) * chromosome.map { |gene| 1.0 / gene**2.0 }.reduce(:+))
    end
  end

  # Method to perform crossover operation over chromosomes
  # @return [void]
  def cross_individuals(selected_offset)
    pp '=> crossing individuals'
    m = selected_offset
    m += 1 if m == 1
    (0...m).each do |x|
      r = Random.rand(1.0)
      # r = @chromosomes[x].prob
      next if r > @cross_rate
      (0...m).each do |y|
        s = Random.rand(1.0)
        # s = @chromosomes[y].prob
        next if s > @cross_rate || x == y
        new_chrom_x, new_chrom_y =
                       HTGA.crossover(chromosome_x: @chromosomes[x].clone,
                                      chromosome_y: @chromosomes[y].clone,
                                      upper_bounds: @upper_bounds,
                                      lower_bounds: @lower_bounds,
                                      continuous: @continuous)
        @chromosomes << new_chrom_x << new_chrom_y
        break
      end
    end
  end

  # Method to perform mutation operation over the chromosomes
  # @return [void]
  def mutate_individuals
    pp '=> mutating individuals'
    m = @chromosomes.size
    (0...m).each do
      r = Random.rand(1.0)
      next if r > @mut_rate
      x = rand(0...m)
      new_chrom = HTGA.mutate @chromosomes[x].clone, continuous: @continuous
      @chromosomes << new_chrom
    end
  end

  # Recalculate the fitness values
  # @return [void]
  def recalculate_fitness
    @chromosomes.map! do |chromosome|
      chromosome.fitness = @selected_func.call chromosome
      chromosome
    end
  end

  # Method that select the best M chromosomes for the next generation
  # @return [void]
  def select_next_generation
    pp "=> selecting next generation"
    if @is_high_fit
      pp "sort in decreasing order"
      # sort in decreasing order by fitness values
      @chromosomes.sort! do |left_chrom, right_chrom|
        right_chrom.fitness <=> left_chrom.fitness
      end
    else
      # sort in increasing order of fitness values
      pp "sort in increasing order"
      @chromosomes.sort! do |left_chrom, right_chrom|
        left_chrom.fitness <=> right_chrom.fitness
      end
    end
    @chromosomes.slice!(@pop_size..@chromosomes.size)
  end

  # Method that selects the most suitable Taguchi array
  # @param [Integer] chrom_size, the number of variables of the function
  def select_taguchi_array
    closest = 0
    [8, 16, 32, 64, 128].each do |n|
      if @num_genes <= n - 1
        closest = n
        break
      end
    end
    file_name = "L#{closest}"
    load_array_from_file file_name
  end

  # Auxiliar method for #select_taguchi_array, it loads the array from a file
  # @param [String] filename, the name of the file which contains the array
  # @param [Integer] chrom_size, the number of variables of the function
  # @return [void]
  def load_array_from_file(filename)
    @taguchi_array = []
    path_to_file = File.join(File.dirname(__FILE__), '..',
                             "taguchi_orthogonal_arrays/#{filename}")
    array_file = open(path_to_file, 'r')
    array_file.each_line do |line|
      @taguchi_array << line.split(';')[0, @num_genes].map!(&:to_i)
    end
    array_file.close
  end

  # Method to generate the optimal crossovered chromosome
  # @param [Chromosome] chromosome_x, the first chromosome
  # @param [Chromosome] chromosome_y, the second chromosome
  # @return [Chromosome] the optimal chromosome
  def generate_optimal_chromosome(chromosome_x, chromosome_y)
    optimal_chromosome = Chromosome.new
    experimental_matrix = generate_experimental_matrix chromosome_x,
                                                       chromosome_y
    # Calculate fitness and SNR values
    experimental_matrix.each_index do |i|
      # experimental_matrix[i].fitness = @selected_func.call experimental_matrix[i]
      HTGA.calculate_snr experimental_matrix[i], smaller_the_better: !@is_high_fit
    end
    # Calculate the effects of the various factors
    (0...experimental_matrix[0].size).each do |j|
      sum_lvl_1 = 0.0
      sum_lvl_2 = 0.0
      (0...experimental_matrix.size).each do |i|
        if @taguchi_array[i][j] == 1
          sum_lvl_2 += experimental_matrix[i].snr
        else
          sum_lvl_1 += experimental_matrix[i].snr
        end
      end
      if sum_lvl_1 > sum_lvl_2
        optimal_chromosome << chromosome_x[j]
      else
        optimal_chromosome << chromosome_y[j]
      end
    end
    # Find the optimal fitness value
    optimal_chromosome.fitness = @selected_func.call optimal_chromosome
    # Return the optimal chromosome
    optimal_chromosome
  end

  def generate_offspring_by_taguchi_method
    expected_number = 0.5 * @pop_size * @cross_rate
    pp '=> generate_offspring_by_taguchi_method'
    pp "expected_number #{expected_number}"
    n = 0
    m = @chromosomes.size
    while n < expected_number
      loop do
        x = rand(0...m)
        y = rand(0...m)
        next if x == y
        chromosome_x = @chromosomes[x]
        chromosome_y = @chromosomes[y]
        opt_chromosome = generate_optimal_chromosome chromosome_x, chromosome_y
        @chromosomes << opt_chromosome
        break
      end
      n += 1
    end
  end

  # Auxiliar method to generate experiments matrix for the optimal crossovered
  # chromosome
  # @param [Chromosome] chromosome_x, the first chromosome
  # @param [Chromosome] chromosome_y, the second chromosome
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
      end
      experimental_matrix << row_chromosome
    end
    experimental_matrix
  end


  # Method to generate the initial population of chromosomes
  # @return [void]
  def init_population
    pp "=>initializing population"
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        if @values == 'discrete'
          beta = (Array.new(11) { |k| k / 10.0 }).sample
        elsif @values == 'uniform distribution'
          beta = Random.rand(1.0)
        end
        gene = @lower_bounds[i] + beta * (@upper_bounds[i] -
                                                 @lower_bounds[i])
        if @continuous
          chromosome << gene
        else
          chromosome << gene.floor
        end
      end
      chromosome.fitness = @selected_func.call chromosome.clone
      @chromosomes << chromosome
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  dim = 30
  bound = 1.28
  htga = HTGA.new values: 'discrete',
                  upper_bounds: Array.new(dim, bound),
                  lower_bounds: Array.new(dim, -1 * bound),
                  pop_size: 200,
                  cross_rate: 0.1,
                  mut_rate: 0.02,
                  num_genes: dim,
                  continuous: true,
                  selected_func: 12,
                  is_negative_fit: false,
                  is_high_fit: false,
                  max_generation: 1000

  htga.execute


end
