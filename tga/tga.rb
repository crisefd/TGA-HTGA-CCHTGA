# language: english
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 07-03-2015
require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# @author Oscar Tigreros
# Main class for the Traditional Genetic Algorithm
class TGA < BaseGA
  
  attr_reader :mating_pool, :new_generation, :num_genes, :chromosomes, :pop_size
  
  def initialize(**input)
    @optimal_func_val = OPTIMAL_FUNCTION_VALUES[input[:selected_func] - 1]
    @pop_size = input[:pop_size]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuous = input[:continuous]
    input[:selected_func] = 0 if input[:selected_func].nil?
    @selected_func = TEST_FUNCTIONS[input[:selected_func] - 1]
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
    @mating_pool = []
    @new_generation = []
    @num_evaluations = 0
    @best_fit = nil
  end

  # Main methon for TGA.
  def execute
    output_hash = {}
    @generation = 1
    begin
      init_population
      while @generation <= @max_generation
        tournament
        cross_cut_point_mating_pool
        mutate_matingpool
        insert_new_generation
        break if @best_fit == @optimal_func_val
        @generation += 1
        relative_error = (((@best_fit + 1) / (@optimal_func_val + 1)) - 1).abs
        output_hash.merge! best_fit: @best_fit, gen_of_best_fit: @gen_of_best_fit,
                           func_evals_of_best_fit: @func_evals_of_best_fit,
                           optimal_func_val: @optimal_func_val,
                           relative_error: relative_error
      end
    rescue StandardError => error
      p error.message
      p error.backtrace.inspect
    end
    output_hash
  end

  # Method to select chromosomes by tournamet default  k=2
  # @return [void]
  def tournament
    k = 2
    x = -1
    y = -1
    prev_chromo = -1
    k.times do
      until (x != y) && (x != prev_chromo) && (y != prev_chromo)
        x = rand(0...@pop_size)
        y = rand(0...@pop_size)
      end
      if @is_high_fit
        if @chromosomes[x].fitness <= @chromosomes[y].fitness
          @mating_pool << @chromosomes[y]
          prev_chromo = y
        elsif @chromosomes[y].fitness < @chromosomes[x].fitness
          @mating_pool << @chromosomes[x]
          prev_chromo = x
        end
      else
        if @chromosomes[x].fitness <= @chromosomes[y].fitness
          @mating_pool << @chromosomes[x]
          prev_chromo = x
        elsif @chromosomes[y].fitness < @chromosomes[x].fitness
          @mating_pool << @chromosomes[y]
          prev_chromo = y
        end
      end
    end
  end

  # Crossing the chrosomes in the mating pool
  # @return [void]
  def cross_cut_point_mating_pool
    cut_point = rand(0...@num_genes)
    chromosome_x = @mating_pool[0].clone
    chromosome_y = @mating_pool[1].clone
    (cut_point...@num_genes).each do |i|
      temp_cut_x = chromosome_x[i]
      temp_cut_y = chromosome_y[i]
      chromosome_x[i] = temp_cut_y
      chromosome_y[i] = temp_cut_x
    end
    @new_generation << chromosome_y << chromosome_x
  end

  # Mutates the chromosomes in the mating pool
  # @return [void]
  def mutate_matingpool
    (0...@mating_pool.size).each do |i|
      gene = -1
      mutate_point = rand(0...@num_genes)
      chromosome = @mating_pool[i].clone
      if @continuous
        gene = rand(lower_bounds[0].to_f..upper_bounds[0].to_f)
      else
        gene = rand(lower_bounds[0].to_i..upper_bounds[0].to_i)
      end
      chromosome[mutate_point] = gene
      @new_generation << chromosome
    end
  end

  # Insert the new chromosomes into the population
  # @return [void]
  def insert_new_generation
    (0...@new_generation.size).each do |i|
      evaluate_chromosome @new_generation[i]
      j = rand 0...@chromosomes.size
      @chromosomes.delete_at j
      verify_best_fit @new_generation[i]
      @chromosomes << @new_generation[i]
    end
    @mating_pool.clear
    @new_generation.clear
  end

  # Verify if the chromosome has a better fitness
  # @param [Chromosome] chromosome
  # @return [void]
  def verify_best_fit(chromosome)
    if @is_high_fit
      @best_fit = chromosome.fitness if @best_fit.nil? || chromosome.fitness > @best_fit
      @gen_of_best_fit = @generation
      @func_evals_of_best_fit = @num_evaluations
    else
      @best_fit = chromosome.fitness if @best_fit.nil? || chromosome.fitness < @best_fit
      @gen_of_best_fit = @generation
      @func_evals_of_best_fit = @num_evaluations
    end
  end

  # Method to generate the initial population of chromosomes
  # @return [void]
  def init_population
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        gene = nil
        if @continuous
          gene = rand(lower_bounds[i].to_f..upper_bounds[i].to_f)
        else
          gene = rand(lower_bounds[i].to_i..upper_bounds[i].to_i)
        end
        chromosome << gene
      end
      evaluate_chromosome chromosome
      verify_best_fit chromosome
      @chromosomes << chromosome
    end
  end
end

if __FILE__ == $PROGRAM_NAME
end
