# language: english
# encoding: utf-8
# Program: cchtga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-04-02

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/subsystem.rb')
require_relative 'ihtga'

# @author Cristhian Fuertes
# Main class for the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm
class CCHTGA < BaseGA
  attr_accessor :best_chromosome
  attr_reader :prev_best_chromosome
  attr_reader :subsystems
  attr_writer :num_genes
  attr_writer :chromosomes
  attr_writer :selected_func

  def initialize(**input)
    super input
    @best_chromosome = nil
    @prev_best_chromosome = nil
  end

  # Method to execute the CCHTGA
  def execute
    @generation = 0
    output_hash = { best_fit: nil, gen_of_best_fit: 0, func_evals_of_best_fit: 0,
                    relative_error: nil, num_subsystems: 0
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
        update_prev_best_chhromosome
        apply_htga_to_subsystems
        # if @generation % 50 == 0 && @generation > 1
        #   p "Generation: #{@generation} - current best fitness: #{output_hash[:best_fit]} current best fit gen: #{output_hash[:gen_of_best_fit]} "
        #   p "Best chromo fitness: #{@best_chromosome.fitness}"
        # end
        update_output_hash output_hash
        break if has_stopping_criterion_been_met? output_hash[:best_fit]
        @generation += 1
      end
      relative_error = (((output_hash[:best_fit] + 1) /
      (@optimal_func_val + 1)) - 1).abs
      output_hash[:relative_error] = relative_error
      output_hash[:num_subsystems] = @subsystems.size
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
      exit
    end
    output_hash
  end

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

  # Method to determine if this generation has improved with respect to the
  # previous one.
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

  # Method that selects the most suitable Taguchi array
  # @param [Integer] chrom_size, the number of variables of the function
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

  # Auxiliar method for #select_taguchi_array, it loads the array from a file
  # @param [String] filename, the name of the file which contains the array
  # @param [Integer] chrom_size, the number of variables of the function
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
  # @return [void]
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
      @subsystems[j].clear if @subsystems[j].size > 0
      (0...@genes_per_group).each do
        gene = available_genes.delete_at(rand(available_genes.size))
        @subsystems[j] << gene
      end
    end
  end

  # Method to perform cooperative coevolution subroutine
  # @return [void]
  def cooperative_coevolution
    @subsystems.each do |subsystem|
      (0...@pop_size).each do |i|
        update_subsystem_best_experiences subsystem, i
        update_subsystem_best_chromosome subsystem, i
      end
      update_best_chromosome subsystem
      correct_best_chromosome_genes
      evaluate_chromosome @best_chromosome
    end
  end

  # Method to update the best chromosomes' experiences of a subsystem
  # @param [Subsystem] subsystem
  # @param [Integer] i
  # @return [void]
  def update_subsystem_best_experiences(subsystem, i)
    if @is_high_fit
      'not implemented'
    else
      if subsystem.chromosomes[i].fitness <
         subsystem.best_chromosomes_experiences[i].fitness

        subsystem.best_chromosomes_experiences[i] = subsystem.chromosomes[i].clone
      end
    end
  end

  # Method to update the best chromosome of a subsystem
  # @param [Subsystem] subsystem
  # @param [Integer] i
  # @return [void]
  def update_subsystem_best_chromosome(subsystem, i)
    if @is_high_fit
      'not implemented'
    else
      if subsystem.best_chromosomes_experiences[i].fitness <
         subsystem.best_chromosome.fitness

        subsystem.best_chromosome = subsystem.best_chromosomes_experiences[i].clone
      end
    end
  end

  # Method to update the best chromosome using the jth part of a subsystem
  # @param [Subsystem] subsystem
  # @param [Integer] i
  # @return [void]
  def update_best_chromosome(subsystem)
    if @is_high_fit
      fail 'not implemented'
    else
      if subsystem.best_chromosome.fitness < @best_chromosome.fitness
        replace_subsystem_part_in_chromosome subsystem
      end
    end
  end

  # Method to replace the jth parth (subsystem's variables) in
  # the best chromosome
  # @return [void]
  def replace_subsystem_part_in_chromosome(subsystem)
    subsystem.each_with_index do |g, i|
      gene = subsystem.best_chromosome[i]
      @best_chromosome[g] = gene
    end
  end

  # Method to correct genes in case a the best chromosome exceeds the bounds
  # @note The search space is doubled in each dimension and reconnected
  # from the opposite bounds to avoid discontinuities
  def correct_best_chromosome_genes
    i = 0
    @best_chromosome.map! do |gene|
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

  def update_prev_best_chhromosome
    @prev_best_chromosome = @best_chromosome.clone
    if @is_high_fit
      @best_chromosome = (@chromosomes.max_by(&:fitness))
    else
      @best_chromosome = (@chromosomes.min_by(&:fitness))
    end
  end

  # Method to apply the ICHTGA to each subsystem
  # return [void]
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
                        mutation_prob: 0.5,
                        taguchi_array: @taguchi_array
      ihtga.execute
      @num_evaluations += ihtga.subsystem.num_evaluations
      rejoin_chromosomes subsystem
    end
  end

  # Method to rejoin the subchromosomes into chromosomes
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

  # Method to create sub chromosomes for the ICHTGA' subsystems
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
  # f1
  cchtga = CCHTGA.new beta_values: 'discrete',
                  upper_bounds: Array.new(100, 500),
                  lower_bounds: Array.new(100, -500),
                  pop_size: 200,
                  cross_rate: 0.1,
                  mut_rate: 0.02,
                  num_genes: 100,
                  continuous: true,
                  selected_func: 1,
                  is_negative_fit: true,
                  is_high_fit: false,
                  max_generation: 10_000
  p cchtga.execute

  # f2 se acerco al valor reportado

  cchtga = CCHTGA.new beta_values: 'discrete',
                  upper_bounds: Array.new(30, 5.12),
                  lower_bounds: Array.new(30, -5.12),
                  pop_size: 30,
                  cross_rate: 0.8,
                  mut_rate: 0.7,
                  num_genes: 30,
                  continuous: true,
                  selected_func: 2,
                  is_negative_fit: false,
                  is_high_fit: false,
                  max_generation: 10000
  p cchtga.execute

  # f3

  cchtga = CCHTGA.new beta_values: 'discrete',
                  upper_bounds: Array.new(100, 32),
                  lower_bounds: Array.new(100, -32),
                  pop_size: 200,
                  cross_rate: 0.8,
                  mut_rate: 0.7,
                  num_genes: 100,
                  continuous: true,
                  selected_func: 3,
                  is_negative_fit: false,
                  is_high_fit: false,
                  max_generation: 10_000
  p cchtga.execute


  # f4

  cchtga = CCHTGA.new beta_values: 'discrete',
                  upper_bounds: Array.new(100, 600),
                  lower_bounds: Array.new(100, -600),
                  pop_size: 30,
                  cross_rate: 0.8,
                  mut_rate: 0.7,
                  num_genes: 100,
                  continuous: true,
                  selected_func: 4,
                  is_negative_fit: false,
                  is_high_fit: false,
                  max_generation: 10_000
  p cchtga.execute

  # f10
  cchtga = CCHTGA.new beta_values: 'discrete',
                      upper_bounds: Array.new(100, 10),
                      lower_bounds: Array.new(100, -5),
                      pop_size: 30,
                      cross_rate: 0.8,
                      mut_rate: 0.7,
                      num_genes: 100,
                      continuous: true,
                      selected_func: 10,
                      is_negative_fit: true,
                      is_high_fit: false,
                      max_generation: 10_000
  p cchtga.execute

  # f11 se acerco al valor reportado

  cchtga = CCHTGA.new beta_values: 'discrete',
                      upper_bounds: Array.new(100, 100),
                      lower_bounds: Array.new(100, -100),
                      pop_size: 30,
                      cross_rate: 0.8,
                      mut_rate: 0.7,
                      num_genes: 100,
                      continuous: true,
                      selected_func: 11,
                      is_negative_fit: false,
                      is_high_fit: false,
                      max_generation: 10_000
  p cchtga.execute

  # f15
  cchtga = CCHTGA.new beta_values: 'discrete',
                      upper_bounds: Array.new(100, 100),
                      lower_bounds: Array.new(100, -100),
                      pop_size: 30,
                      cross_rate: 0.8,
                      mut_rate: 0.7,
                      num_genes: 100,
                      continuous: true,
                      selected_func: 15,
                      is_negative_fit: false,
                      is_high_fit: false,
                      max_generation: 10_000
  p cchtga.execute
end
