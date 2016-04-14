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

# clase principal
class TGA < BaseGA
  def initialize(**input)
    @values = input[:values]
    @pop_size = input[:pop_size]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuos = input[:continuos]
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
    @generation = 1
    # init_time = Time.now
    begin
      init_population
      while @generation <= @max_generation
        tournament
        cross_cut_point_mating_pool
        mutate_matingpool
        insert_new_generation
        break if @best_fit == @optimal_func_val
        @generation += 1
         p "pop:"+ (@chromosomes.size.to_s) +  " Bf: "+ (@best_fit.to_s) +" maxG: "+(@max_generation.to_s) +" gen: "+ @generation.to_s
      end
    end
  end

  # Method to select chromosomes by tournamet default  k=2
  # @return [void]
  def tournament
    k = 2
    x = -1
    y = -1
    prev_chromo = -1
    k.times {
      until (x != y) && (x != prev_chromo) && (y != prev_chromo)
        x = rand(0...@pop_size)
        y = rand(0...@pop_size)
      end
      if @chromosomes[x].fitness <= @chromosomes[y].fitness
        @mating_pool << @chromosomes[y]
        prev_chromo = y
      elsif @chromosomes[y].fitness < @chromosomes[x].fitness
        @mating_pool << @chromosomes[x]
        prev_chromo = x
      end
    }
  end
  # uniform cross 1 cut point
  def cross_cut_point_mating_pool
    cut_point = rand(0...@num_genes)
    chromosome_x = @mating_pool[0]
    chromosome_y = @mating_pool[1]
    temp_cut_x = -1
    temp_cut_y = -1
    (cut_point...@num_genes).each do |i|
      temp_cut_x = chromosome_x[i]
      temp_cut_y = chromosome_y[i]
      chromosome_x[i] = temp_cut_y
      chromosome_y[i] = temp_cut_x
    end
    @new_generation << chromosome_y
    @new_generation << chromosome_x
  end

  # GENERAL MUTATE FOR n CHROMOSOMES POOL
  def mutate_matingpool
    (0...@mating_pool.size).each do |i|
      mutate_point = rand(0...@num_genes)
      chromosome = @mating_pool[i]
      if @continuous
        gene = rand(lower_bounds[mutate_point].to_i..upper_bounds[mutate_point].to_i)
      else
        gene = rand(lower_bounds[mutate_point].to_f..upper_bounds[mutate_point].to_f)
      end
      chromosome[mutate_point] = gene
      @new_generation << chromosome
    end
  end

  # Insert the new chromosomes into the population
  def insert_new_generation
    calculate_fitness @new_generation
    (0...4).each do
      x = rand(0...@chromosomes.size)
      @chromosomes.delete_at(x)
    end
    (0...@new_generation.size).each do |x|
      best_fit? @new_generation[x]
      @chromosomes << @new_generation[x]
    end
    @mating_pool.clear
    @new_generation.clear
  end

  # Verify if the chromosome has a better fitness
  def best_fit?(chromosome)
    if @is_high_fit
      @best_fit = chromosome.fitness if @best_fit.nil? || chromosome.fitness > @best_fit
    else
      @best_fit = chromosome.fitness if @best_fit.nil? || chromosome.fitness < @best_fit
    end
  end

  # calculate the fitness of bunch of chromosomes
  def calculate_fitness(chromosomes_clust)
    # p chromosomes_clust.size
    (0...chromosomes_clust.size).each do |i|
      chromosomes_clust[i].fitness = @selected_func.call chromosomes_clust[i]
      @num_evaluations += 1
    end
  end

  # Method to generate the initial population of chromosomes
  # @return [void]
  def init_population
    y = @pop_size
    (0...y).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        if @continuous
          gene = rand(lower_bounds[i].to_i..upper_bounds[i].to_i)
        else
          gene = rand(lower_bounds[i].to_f..upper_bounds[i].to_f)
        end
        chromosome << gene
      end
      @chromosomes << chromosome
    end
    calculate_fitness @chromosomes
    (0...@chromosomes.size).each do |i|
      best_fit? @chromosomes[i]
    end
  end
end
if __FILE__ == $PROGRAM_NAME
  dim = 30
  bound = 1.28
  tga = TGA.new values: 'discrete',
                upper_bounds: Array.new(dim, bound),
                lower_bounds: Array.new(dim, -1 * bound),
                pop_size: 200,
                # cross_rate: 0.1,
                # mut_rate: 0.02,
                num_genes: dim,
                continuous: true,
                selected_func: 12,
                is_negative_fit: false,
                is_high_fit: false,
                max_generation: 10000000
  tga.execute
end
