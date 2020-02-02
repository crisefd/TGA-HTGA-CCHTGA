# frozen_string_literal: true

# language: en

# program: htga.rb
# creation date: 2015-10-05
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# Main class for the Hybrid-Taguchi Genetic Algorithm
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class HTGA < BaseGA
  # @!attribute taguchi_array
  # @return [Array<Array>] The selected Taguchi array for matrix experiments
  attr_accessor :taguchi_array

  # @param [Hash] input The input values for the algorithm
  # @option input [String] :beta_values The type of random numbers
  # (discrete | uniform distribution) to be use in {#init_population}
  # @option input [Array] :upper_bounds The upper bounds for the genes
  # @option input [Array] :lower_bounds The lower bounds for the genes
  # @option input [Integer] :pop_size The number of chromosomes the population
  # @option input [Float] :cross_rate The crossover rate
  # @option input [Float] :mut_rate The mutation rate
  # @option input [Integer] :num_genes The number of genes in a chromosome
  # @option input [Boolean] :continuous Flag to indicate if
  # the problem being solved is continuous or discrete
  # @option input [Integer] :selected_function
  # The number of the test function (f1, f2,...,f15) to solved
  # @option input [Boolean] :is_high_fit
  # Flag to indicate if the problem to be resolved
  # is a maximization or minimization problem
  # @option input [Float] :optimal_func_val
  # The best known value for the problem being solved
  # @option input [Integer] :max_generation The max number of generations
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
    @optimal_func_val = input[:optimal_func_val] if @optimal_func_val.nil?
    @is_high_fit = input[:is_high_fit]
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
    @num_evaluations = 0
  end

  # Main method for the HTGA
  # @return [Hash] The output variables:
  # best fitness, number of generations,
  # number of fitness evaluation, relative error and optimal value
  def execute
    @generation = 0
    output_hash = { best_fit: nil, gen_of_best_fit: 0, func_evals_of_best_fit: 0,
                    relative_error: nil, optimal_func_val: nil }
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
        if (@generation % 50).zero?
          p "Generation: #{@generation}- Fitness: #{@chromosomes.first.fitness}"
        end
        update_output_hash output_hash
        break if has_stopping_criterion_been_met? output_hash[:best_fit]
        @generation += 1
      end
      relative_error = (((output_hash[:best_fit] + 1) / (@optimal_func_val + 1)) - 1).abs
      output_hash[:relative_error] = relative_error
      output_hash[:optimal_func_val] = @optimal_func_val
    rescue StandardError => e
      p e.message
      p e.backtrace.inspect
    end
    p output_hash
    output_hash
  end

  # Updates the output variables in each generation
  # @param [Hash] output_hash A hash object with the output variables
  # @return [nil]
  def update_output_hash(output_hash)
    if output_hash[:best_fit].nil? ||
       (@chromosomes.first.fitness < output_hash[:best_fit] && !@is_high_fit) ||
       (@chromosomes.first.fitness > output_hash[:best_fit] && @is_high_fit)

      output_hash[:best_fit] = @chromosomes.first.fitness
      output_hash[:gen_of_best_fit] = @generation
      output_hash[:func_evals_of_best_fit] = @num_evaluations
    end
  end

  # Crossover operator
  # @param [Chromosome] chromosome_x First parent chromosome
  # @param [Chromosome] chromosome_y Second parent chromosome
  # @return [Array<Chromosome>]  the resulting crossovered chromosomes
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

  # Mutation operator method for the chromosomes
  # @param [Chromosome] chromosome The parent chromosome
  # @return [Chromosome] The resulting mutated chromosome
  # @note Does not work for discrete functions
  def mutate(chromosome)
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
    if @continuous # Doesn't work for discrete functions
      chromosome[i] = (1 - beta) * gene_i + beta * gene_k
      chromosome[k] = beta * gene_i + (1 - beta) * gene_k
    else
      chromosome[i] = ((1 - beta) * gene_i + beta * gene_k).floor
      chromosome[k] = (beta * gene_i + (1 - beta) * gene_k).floor
    end
    chromosome
  end

  # Perfoms SNR calculation
  # @param [Chromosome] chromosome The chromosome at which its SNR value
  # is calculated
  # @return [nil]
  def calculate_snr(chromosome)
    n = chromosome.size.to_f
    if @is_high_fit # What happens when the gene is 0 ?
      chromosome.snr = -10.0 * Math.log10((1.0 / n) *
                        chromosome.map { |gene| 1.0 / gene**2.0 }.reduce(:+))
    else
      chromosome.snr = -10.0 * Math.log10((1.0 / n) *
                        chromosome.map { |gene| gene**2.0 }.reduce(:+))
    end
  end

  # Performs crossover operation and add the new chromosomes to the population
  # @param [Array] selected_indexes The selected chromosomes' indexes
  # @param [Symbol] select_method The selection method
  # @return [nil]
  def cross_individuals(selected_indexes, select_method: :roulette)
    if select_method == :roulette
      m = selected_indexes.size
      (0...m).each do
        x = selected_indexes.sample
        y = selected_indexes.sample
        new_chrom_x, new_chrom_y =
          crossover @chromosomes[x].clone, @chromosomes[y].clone
        evaluate_chromosome new_chrom_x
        evaluate_chromosome new_chrom_y
        @chromosomes << new_chrom_x << new_chrom_y
      end
    elsif select_method == :tournament
      m = selected_indexes.size - 1
      (0...m).each do
        x = selected_indexes.sample
        y = selected_indexes.sample
        new_chrom_x, new_chrom_y =
          crossover @chromosomes[x].clone, @chromosomes[y].clone
        evaluate_chromosome new_chrom_x
        evaluate_chromosome new_chrom_y
      end
    end
  end

  # Performs mutation operation and add the new chromosomes to the population
  # @return [nil]
  def mutate_individuals
    m = @chromosomes.size
    (0...m).each do |x|
      r = rand(0.0..1.0)
      next if r > @mut_rate

      new_chrom = mutate @chromosomes[x].clone
      evaluate_chromosome new_chrom
      @chromosomes << new_chrom
    end
  end

  # Selects the best M (population size) chromosomes for the next generation
  # @return [nil]
  def select_next_generation
    if @is_high_fit
      # sort in decreasing order by fitness values
      @chromosomes.sort! do |left_chrom, right_chrom|
        right_chrom.fitness <=> left_chrom.fitness
      end
    else
      # sort in increasing order of fitness values
      @chromosomes.sort! do |left_chrom, right_chrom|
        left_chrom.fitness <=> right_chrom.fitness
      end
    end
    @chromosomes.slice!(@pop_size..@chromosomes.size)
  end

  # Selects the most suitable Taguchi array
  # @return [nil]
  def select_taguchi_array
    closest = 0
    [8, 16, 32, 64, 128, 256, 512, 1024].each do |n|
      if @num_genes <= n - 1
        closest = n
        break
      end
    end
    file_name = "L#{closest}"
    load_array_from_file file_name
  end

  # Loads Taguchi array from file
  # @param [String] filename The file name
  # @return [nil]
  def load_array_from_file(filename)
    @taguchi_array = []
    path_to_file =
      File.join(File.dirname(__FILE__),
                '..',
                "taguchi_orthogonal_arrays/#{filename}")
    array_file = File.open(path_to_file, 'r')
    array_file.each_line do |line|
      @taguchi_array << line.split(';')[0, @num_genes].map!(&:to_i)
    end
    array_file.close
  end

  # Generates the optimal crossovered chromosome
  # @param [Chromosome] chromosome_x First parent chromosome
  # @param [Chromosome] chromosome_y Second parent chromosome
  # @return [Chromosome]
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
      optimal_chromosome <<
        if sum_lvl_1 > sum_lvl_2
          chromosome_x[j]
        else
          chromosome_y[j]
        end
    end
    # Find the optimal fitness value
    evaluate_chromosome optimal_chromosome
    # Return the optimal chromosome
    optimal_chromosome
  end

  # Generates offspring using the Taguchi method (Taguchi crossover)
  # @return [nil]
  def generate_offspring_by_taguchi_method
    expected_number = 0.5 * @pop_size * @cross_rate
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

  # Generates experiments matrix for Taguchi crossover
  # @param [Chromosome] chromosome_x The first parent chromosome
  # @param [Chromosome] chromosome_y The second parent chromosome
  # @return [Array<Chromosome>] The experiments matrix
  # @note Each row is an experimental chromosome
  def generate_experiment_matrix(chromosome_x, chromosome_y)
    experiment_matrix = []
    (0...@taguchi_array.size).each do |i|
      row_chromosome = Chromosome.new
      (0...@taguchi_array[0].size).each do |j|
        row_chromosome <<
          if @taguchi_array[i][j].zero?
            chromosome_x[j]
          else
            chromosome_y[j]
          end
      end
      experiment_matrix << row_chromosome
    end
    experiment_matrix
  end

  # Generate the initial population of chromosomes
  # @return [nil]
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
        # Wrong for discrete functions
        chromosome << (@continuous ? gene : gene.floor)
      end
      evaluate_chromosome chromosome
      @chromosomes << chromosome
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  # f1 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 500),
  #                 lower_bounds: Array.new(30, -500),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 1,
  #                 is_negative_fit: true,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall -12568.655014100983"
  # "generation of best fitness 9996"
  # "function evaluations 400393"
  # "Execution time (seconds): 176.504894135"

  # f2 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 5.12),
  #                 lower_bounds: Array.new(30, -5.12),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 2,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 0.0"
  # "generation of best fitness 33"
  # "function evaluations 1195"
  # "Execution time (seconds): 0.628910283"

  # f3 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 32),
  #                 lower_bounds: Array.new(30, -32),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 3,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 4.440892098500626e-16"
  # "generation of best fitness 30"
  # "function evaluations of best fitness 780"
  # "Execution time (seconds): 188.342336139"

  # f4 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 600),
  #                 lower_bounds: Array.new(30, -600),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 4,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 0.0"
  # "generation of best fitness 36"
  # "function evaluations of best fitness 1303"
  # "Execution time (seconds): 0.697401036"

  # f5 se acerco al optimo con subsystems=4

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 50),
  #                 lower_bounds: Array.new(30, -50),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 5,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 0.010480449136671111"
  # "generation of best fitness 6910"
  # "function evaluations of best fitness 359311"
  # "Execution time (seconds): 208.23771955"

  # f6 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 50),
  #                 lower_bounds: Array.new(30, -50),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 6,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 2.9562991214496233e-09"
  # "generation of best fitness 9995"
  # "function evaluations of best fitness 498975"
  # "Execution time (seconds): 193.669437994"

  # f7 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, Math::PI),
  #                 lower_bounds: Array.new(100, 0),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 7,
  #                 is_negative_fit: true,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall -92.2268345505006"
  # "generation of best fitness 9613"
  # "function evaluations of best fitness 466832"
  # "Execution time (seconds): 1614.534575738"

  # f8 funcion muy costosa

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, Math::PI),
  #                 lower_bounds: Array.new(100, -1 * Math::PI),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 8,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # f9 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, 5),
  #                 lower_bounds: Array.new(100, -5),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 9,
  #                 is_negative_fit: true,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall -78.33233140753973"
  # "generation of best fitness 10000"
  # "function evaluations of best fitness 523372"
  # "Execution time (seconds): 1633.606771202"

  # f10 no se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 10),
  #                 lower_bounds: Array.new(30, -5),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 10,
  #                 is_negative_fit: true,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 98.98255812317848"
  # "generation of best fitness 9978"
  # "function evaluations of best fitness 150245"
  # "Execution time (seconds): 1598.60769294

  # f11 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 100),
  #                 lower_bounds: Array.new(30, -100),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 11,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 0.0"
  # "generation of best fitness 34"
  # "function evaluations of best fitness 1232"
  # "Execution time (seconds): 0.57755215"

  # f12 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 1.28),
  #                 lower_bounds: Array.new(30, -1.28),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 12,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 3.5203227273239435e-06"
  # "generation of best fitness 1454"
  # "function evaluations of best fitness 79425"
  # "Execution time (seconds): 190.778915494"

  # f13 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 10),
  #                 lower_bounds: Array.new(30, -10),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 13,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 0.0"
  # "generation of best fitness 36"
  # "function evaluations of best fitness 1004"
  # "Execution time (seconds): 0.672913684"

  # f14 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 100),
  #                 lower_bounds: Array.new(30, -100),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 14,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p htga.execute

  # RESULTS
  # "best fitness overall 0.0"
  # "generation of best fitness 53"
  # "function evaluations of best fitness 2069"
  # "Execution time (seconds): 1.128410878"

  # f15 se acerco al valor reportado

  # htga = HTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(30, 100),
  #                 lower_bounds: Array.new(30, -100),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 30,
  #                 continuous: true,
  #                 selected_func: 15,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10_000
  # p htga.execute

  # RESULTS
  # "best fitness overall 0.0"
  # "generation of best fitness 39"
  # "function evaluations of best fitness 1005"
  # "Execution time (seconds): 0.671060716"

end
