# language: en
# encoding: utf-8
# program: cchtga.rb
# creation date: 2016-04-02
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/subsystem.rb')
require_relative 'ihtga'

# Main class for the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class CCHTGA < BaseGA
  # @!attributes [Chromosome] current best chromosome
  attr_accessor :best_chromosome
  # @!attributes [Chromosome] previous best chromosome
  attr_reader :prev_best_chromosome
  # @!attributes [Array<Subsystem>] list of subsystems
  attr_reader :subsystems
  # @!attributes [Integer] number of genes
  attr_writer :num_genes
  # @!attributes [Array<Chromosome>] population
  attr_writer :chromosomes
  # @!attributes [Integer] the number of the selected function
  attr_writer :selected_func

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
    @best_chromosome = nil
    @prev_best_chromosome = nil
  end

  # Main method
  # @return [Hash]
  def execute
    @generation = 0
    output_hash = {
                     best_fit: nil, gen_of_best_fit: 0, func_evals_of_best_fit: 0,
                     relative_error: nil, num_subsystems: 0, optimal_func_val: nil
                  }
    begin
      init_population
      p 'population initialized'
      divide_variables
      p "variables divided, num of subsystems #{@subsystems.size} -- genes per group #{@genes_per_group}"
      select_taguchi_array
      p "selected taguchi array is L#{@taguchi_array.size}"
      random_grouping
      p 'random grouping for generation 0 '
      while @generation < @max_generation
        random_grouping if @generation > 1 && has_best_fit_not_improved?
        cooperative_coevolution if @generation > 1
        apply_htga_to_subsystems
        update_prev_best_chhromosome
        if @generation % 50 == 0 && @generation > 1
          p "Generation: #{@generation} - current best fitness: #{output_hash[:best_fit]} current best fit gen: #{output_hash[:gen_of_best_fit]} "
          p "Best chromo fitness: #{@best_chromosome.fitness}"
        end
        update_output_hash output_hash
        break if has_stopping_criterion_been_met? output_hash[:best_fit]
        @generation += 1
      end
      relative_error = (((output_hash[:best_fit] + 1) /
                         (@optimal_func_val + 1)) - 1).abs
      output_hash[:relative_error] = relative_error
      output_hash[:num_subsystems] = @subsystems.size
      output_hash[:optimal_func_val] = @optimal_func_val
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
    end
    output_hash
  end

  # Updates the output variables
  # @param [Hash] output_hash
  # @return [void]
  def update_output_hash(output_hash)
    if output_hash[:best_fit].nil? ||
       (@best_chromosome.fitness < output_hash[:best_fit] && !@is_high_fit) ||
       (@best_chromosome.fitness > output_hash[:best_fit] && @is_high_fit)

      output_hash[:best_fit] = @best_chromosome.fitness
      output_hash[:gen_of_best_fit] = @generation
      output_hash[:func_evals_of_best_fit] = @num_evaluations
    end
  end

  # Determines if this generation has improved with respect to the
  # previous one
  # @return [Boolean]
  def has_best_fit_not_improved?
    answer = false
    delta_fit = 0
    if @is_high_fit
      fail 'not implemeted'
    else
      if @prev_best_chromosome.nil?
        answer = true
      else
        delta_fit = @best_chromosome.fitness - @prev_best_chromosome.fitness
        answer = delta_fit > 0 || delta_fit < @prev_best_chromosome.fitness * 0.1
      end
    end
    answer
  end

  # Selects the most suitable Taguchi array
  # @return [void]
  def select_taguchi_array
    closest = 0
    [8, 16, 32, 64, 128, 256, 512].each do |n|
      if @genes_per_group <= n - 1
        closest = n
        break
      end
    end
    file_name = "L#{closest}"
    @taguchi_array = load_array_from_file file_name
  end

  # Loads the Taguchi array from file
  # @param [String] filename
  # @param [Integer] chrom_size
  # @return [void]
  def load_array_from_file(filename)
    taguchi_array = []
    path_to_file = File.join(File.dirname(__FILE__), '..',
                             "taguchi_orthogonal_arrays/#{filename}")
    array_file = open(path_to_file, 'r')
    array_file.each_line do |line|
      taguchi_array << line.split(';')[0, @genes_per_group].map!(&:to_i)
    end
    array_file.close
    taguchi_array
  end

  # Calculate a list of divisors for n = number of variables
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

  # Divides the N variables into K subsystems
  # @return [void]
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

  # Performs random grouping
  # @return [void]
  def random_grouping
    available_genes = (0...@num_genes).to_a
    (0...@subsystems.size).each do |j|
      @subsystems[j].clear if @subsystems[j].size > 0
      (0...@genes_per_group).each do
        gene = available_genes.delete_at(rand(available_genes.size))
        @subsystems[j] << gene
      end
    end
  end

  # Performs cooperative coevolution subroutine
  # @return [void]
  # @note Cooperation is achieved through the use of bes_chromosome and 
  # prev_best_chromosome attributes. Coevolution is achieved through the use of
  # the #best function
  def cooperative_coevolution
    @subsystems.map! do |subsystem|
      (0...@pop_size).each do |i|
        update_subsystem_best_experiences subsystem, i
        update_subsystem_best_chromosome subsystem, i
      end
      update_best_chromosome subsystem
      evaluate_chromosome @best_chromosome
      subsystem
    end
  end

  # Replaces the subchromosome's genes in the best chromosome
  # and calculates the fitness for the this temp best chromosome.
  # @param [Subsystem] subsystem
  # @param [Chromosome] chromosome
  # @return [Chromosome]
  def best(subsystem, chromosome)
    best_chromosome = @best_chromosome.clone
    subsystem.each_with_index do |g, k|
      best_chromosome[g] = chromosome[k]
    end
    evaluate_chromosome best_chromosome
    best_chromosome
  end

  # Updates the best chromosomes' experiences of a subsystem
  # @param [Subsystem] subsystem
  # @param [Integer] i
  # @return [void]
  def update_subsystem_best_experiences(subsystem, i)
    if @is_high_fit
      fail 'not implemented'
    else
      if best(subsystem, subsystem.chromosomes[i]).fitness <
         best(subsystem, subsystem.best_chromosomes_experiences[i]).fitness

        subsystem.best_chromosomes_experiences[i] = subsystem.chromosomes[i].clone
      end
    end
  end

  # Updates the best chromosome of a subsystem
  # @param [Subsystem] subsystem
  # @param [Integer] i
  # @return [void]
  def update_subsystem_best_chromosome(subsystem, i)
    if @is_high_fit
      fail 'not implemented'
    else
      if best(subsystem, subsystem.best_chromosomes_experiences[i]).fitness <
         best(subsystem, subsystem.best_chromosome).fitness

        subsystem.best_chromosome = subsystem.best_chromosomes_experiences[i].clone
      end
    end
  end

  # Updates the best chromosome using the jth part of a subsystem
  # @param [Subsystem] subsystem
  # @return [void]
  def update_best_chromosome(subsystem)
    if @is_high_fit
      fail 'not implemented'
    else
      if best(subsystem, subsystem.best_chromosome).fitness < @best_chromosome.fitness
        replace_subsystem_part_in_chromosome subsystem
      end
    end
  end

  # Replaces the jth parth (subsystem's variables) in
  # the best chromosome
  # @return [void]
  def replace_subsystem_part_in_chromosome(subsystem)
    subsystem.each_with_index do |g, i|
      gene = subsystem.best_chromosome[i]
      @best_chromosome[g] = gene
    end
  end

  # Generates the initial population of chromosomes
  # @return [void]
  # @note It also initialize the best chromosome
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

  # Updates the previous best chromosome
  # @return [void]
  def update_prev_best_chhromosome
    @prev_best_chromosome = @best_chromosome.clone
    if @is_high_fit
      @best_chromosome = (@chromosomes.max_by(&:fitness))
    else
      @best_chromosome = (@chromosomes.min_by(&:fitness))
    end
  end

  # Apply the IHTGA subroutine to each subsystem
  # return [void]
  def apply_htga_to_subsystems
    @subsystems.map! do |subsystem|
      sub_chromosomes, upper_bounds, lower_bounds = decompose_chromosomes subsystem
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
                        mutation_prob: 0.5,
                        taguchi_array: @taguchi_array
      ihtga.execute
      @num_evaluations += ihtga.subsystem.num_evaluations
      rejoin_chromosomes subsystem
      subsystem
    end
  end

  # Rejoin the subchromosomes into chromosomes
  # @param [Subsystem] subsystem
  # @return [void]
  def rejoin_chromosomes(subsystem)
    sub_chromosomes = subsystem.chromosomes
    sub_chromosomes.each_with_index do |subchromo, i|
      subsystem.each_with_index do |g, j|
        @chromosomes[i][g] = subchromo[j]
      end
      evaluate_chromosome @chromosomes[i]
    end
  end

  # Creates sub chromosomes
  # @param [Subsystem] subsystem
  # @return [Array<Chromosomes>, Array<Float>, Array<Float>]
  def decompose_chromosomes(subsystem)
    sub_chromosomes = Array.new(@pop_size) { Chromosome.new }
    lower_bounds = []
    upper_bounds = []
    subsystem.each do |g|
      lower_bounds << @lower_bounds[g]
      upper_bounds << @upper_bounds[g]
      @chromosomes.each_with_index do |chromosome, i|
        sub_chromosomes[i] << chromosome[g]
      end
    end
    [sub_chromosomes, upper_bounds, lower_bounds]
  end

end

if __FILE__ == $PROGRAM_NAME
  # f1 alcanzo el optimo
  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, 500),
  #                 lower_bounds: Array.new(100, -500),
  #                 pop_size: 200,
  #                 cross_rate: 0.1,
  #                 mut_rate: 0.02,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 1,
  #                 is_negative_fit: true,
  #                 is_high_fit: false,
  #                 max_generation: 10_000
  # p cchtga.execute

  # f2 se acerco al valor reportado

  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, 5.12),
  #                 lower_bounds: Array.new(100, -5.12),
  #                 pop_size: 30,
  #                 cross_rate: 0.8,
  #                 mut_rate: 0.7,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 2,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10000
  # p cchtga.execute

  # f3 le falta para acercarse al valor reportado

  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, 32),
  #                 lower_bounds: Array.new(100, -32),
  #                 pop_size: 200,
  #                 cross_rate: 0.8,
  #                 mut_rate: 0.7,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 3,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10_000
  # p cchtga.execute


  # f4 se acerco al valor reportado con subsystems= 4

  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, 600),
  #                 lower_bounds: Array.new(100, -600),
  #                 pop_size: 30,
  #                 cross_rate: 0.8,
  #                 mut_rate: 0.7,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 4,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10_000
  # p cchtga.execute

  # f5

  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                 upper_bounds: Array.new(100, 50),
  #                 lower_bounds: Array.new(100, -50),
  #                 pop_size: 30,
  #                 cross_rate: 0.8,
  #                 mut_rate: 0.7,
  #                 num_genes: 100,
  #                 continuous: true,
  #                 selected_func: 5,
  #                 is_negative_fit: false,
  #                 is_high_fit: false,
  #                 max_generation: 10_000
  # p cchtga.execute

  # f10 alcanzo el optimo, con subsystems = 5
  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                     upper_bounds: Array.new(100, 10),
  #                     lower_bounds: Array.new(100, -5),
  #                     pop_size: 30,
  #                     cross_rate: 0.8,
  #                     mut_rate: 0.7,
  #                     num_genes: 100,
  #                     continuous: true,
  #                     selected_func: 10,
  #                     is_negative_fit: true,
  #                     is_high_fit: false,
  #                     max_generation: 10_000
  # p cchtga.execute

  # f11 se acerco al valor reportado con subsystems=4

  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                     upper_bounds: Array.new(100, 100),
  #                     lower_bounds: Array.new(100, -100),
  #                     pop_size: 30,
  #                     cross_rate: 0.8,
  #                     mut_rate: 0.7,
  #                     num_genes: 100,
  #                     continuous: true,
  #                     selected_func: 11,
  #                     is_negative_fit: false,
  #                     is_high_fit: false,
  #                     max_generation: 10_000
  # p cchtga.execute

  # f15 funciona quitando el step en el crossover, subsystem=10
  # cchtga = CCHTGA.new beta_values: 'discrete',
  #                     upper_bounds: Array.new(100, 100),
  #                     lower_bounds: Array.new(100, -100),
  #                     pop_size: 30,
  #                     cross_rate: 0.8,
  #                     mut_rate: 0.7,
  #                     num_genes: 100,
  #                     continuous: true,
  #                     selected_func: 15,
  #                     is_negative_fit: false,
  #                     is_high_fit: false,
  #                     max_generation: 10_000
  # p cchtga.execute
end
