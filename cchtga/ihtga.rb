# language: english
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-05-18

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'htga/htga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# @author Cristhian Fuertes
# Main class for the Improved Hybrid-Taguchi Genetic Algorithm
class IHTGA < HTGA

  # @param [Hash] input, hash list for the initialization
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
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
    @best_chromosome = nil
    @subsystem = input[:subsystem]
    # @num_evaluations = 0 # how to calculate the number of evaluations for cchtga
  end

  def evaluate_chromosome(chromosome)
    
  end

  def execute
  end


  # Method to perfom SNR calculation used in the CCHTGA
 # @param [Chromosome] chromosome, the chromosome
 # @return [void]
 def calculate_snr(chromosome)
   if @is_high_fit
     fail "CCHTGA's SNR calculation for maximization not implemented yet"
   else
     evaluate_chromosome chromosome # Wrong
     # What if the rest equals zero ?
     chromosome.snr = (chromosome.fitness - @best_chromosome.fitness)**-2
   end
 end
end
