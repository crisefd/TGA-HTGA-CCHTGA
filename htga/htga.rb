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

  # Method to perform cross over operation over chromsomes
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
                       Chromosome.crossover(chromosome_x: @chromosomes[x].clone,
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
    # sort in decressing order of fitness values
    @chromosomes.sort! do |left_chrom, right_chrom|
                        right_chrom.fitness <=> left_chrom.fitness
                      end
    @chromosomes.slice!(@pop_size..@chromosomes.size)
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
