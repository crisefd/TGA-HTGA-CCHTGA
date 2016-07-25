# language: english
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# @author Cristhian Fuertes
# Main class for the Hybrid-Taguchi Genetic Algorithm
class HTGA < BaseGA
  # @!attribute [taguchi_array] the selected Taguchi array for matrix
  # experiments
  attr_accessor :taguchi_array

  # Main method for the HTGA
  def execute
    output_hash = {}
    @generation = 0
    best_fit = nil
    gen_of_best_fit = 0
    func_evals_of_best_fit = 0
    begin
      init_population
      p 'population initialized'
      select_taguchi_array
      p "the selected taguchi array is L#{@taguchi_array.size}"
      while @generation < @max_generation
        # selected_indexes = tournament_select @pop_size * @cross_rate
        selected_indexes = roulette_select
        cross_individuals selected_indexes
        generate_offspring_by_taguchi_method
        mutate_individuals
        select_next_generation
        if @generation % 50 == 0
          p "Generation: #{@generation}-Fitness: #{@chromosomes.first.fitness}"
        end
        if @is_high_fit
          if best_fit.nil? || @chromosomes.first.fitness > best_fit
            best_fit = @chromosomes.first.fitness
            gen_of_best_fit = @generation
            func_evals_of_best_fit = @num_evaluations
          end
        else
          if best_fit.nil? || @chromosomes.first.fitness < best_fit
            best_fit = @chromosomes.first.fitness
            gen_of_best_fit = @generation
            func_evals_of_best_fit = @num_evaluations
          end
        end
        break if best_fit <= @optimal_func_val
        @generation += 1
      end
      relative_error = (((best_fit + 1) / (@optimal_func_val + 1)) - 1).abs
      output_hash.merge! best_fit: best_fit, gen_of_best_fit: gen_of_best_fit,
                         func_evals_of_best_fit: func_evals_of_best_fit,
                         optimal_func_val: @optimal_func_val,
                         relative_error: relative_error
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
      output_hash.merge error: error.message
    end
    output_hash
  end

  # Crossover operator method use in HTGA
  # @param [Chromosome] chromosome_x
  # @param [Chromosome] chromosome_y
  # @return [Chromosome, Chromosome]  the resulting crossovered chromosomes.
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
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @return [Chromosome] the resulting mutated chromosome
  def mutate(chromosome) # Does not work for discrete functions
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

  # validate(:mutate) { |*args, &blk| args.reduce(:+) == 6 }

  # Method to perfom SNR calculation used in the HTGA
  # @param [Chromosome] chromosome, the chromosome
  # @return [void]
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
        # loop do
        #   x = selected_indexes.sample
        #   y = selected_indexes.sample
        #   break if x != y
        # end
        # r = rand 0.0..1.0
        # y = -1
        # loop do
        #   y = rand(0...m)
        #   break if x != y
        # end
        # next if r > @cross_rate
        new_chrom_x, new_chrom_y =
                      crossover @chromosomes[x].clone, @chromosomes[y].clone

        evaluate_chromosome new_chrom_x
        evaluate_chromosome new_chrom_y
        @chromosomes << new_chrom_x << new_chrom_y
      end
    elsif select_method == :tournament
      m = selected_indexes.size - 1
      (0...m).each do |j|
        x = selected_indexes.sample
        y = selected_indexes.sample
        new_chrom_x, new_chrom_y =
                      crossover @chromosomes[x].clone, @chromosomes[y].clone
        evaluate_chromosome new_chrom_x
        evaluate_chromosome new_chrom_y
      end
    end
  end

  # Method to perform mutation operation over the chromosomes
  # @return [void]
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

  # Method that select the best M chromosomes for the next generation
  # @return [void]
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

  # Method that selects the most suitable Taguchi array
  # @param [Integer] chrom_size, the number of variables of the function
  def select_taguchi_array
    closest = 0
    [8, 16, 32, 64, 128, 256, 512].each do |n|
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
    evaluate_chromosome optimal_chromosome
    # Return the optimal chromosome
    optimal_chromosome
  end

  # Method to generate offspring using the Taguchi method
  # @return [void]
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

  # Auxiliar method to generate experiments matrix for the optimal crossovered
  # chromosome
  # @param [Chromosome] chromosome_x, the first chromosome
  # @param [Chromosome] chromosome_y, the second chromosome
  # @param [Array<Chromosome>] an array of chromosomes
  def generate_experiment_matrix(chromosome_x, chromosome_y)
    experiment_matrix = []
    (0...@taguchi_array.size).each do |i|
      row_chromosome = Chromosome.new
      (0...@taguchi_array[0].size).each do |j|
        if @taguchi_array[i][j] == 0
          row_chromosome << chromosome_x[j]
        else
          row_chromosome << chromosome_y[j]
        end
      end
      experiment_matrix << row_chromosome
    end
    experiment_matrix
  end

  # Method to generate the initial population of chromosomes
  # @return [void]
  def init_population
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        # beta = 0
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

  # f5 se acerco, pero no  segun lo reportado

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
