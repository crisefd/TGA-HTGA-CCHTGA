# language: english
# encoding: utf-8
# Program: cchtga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-04-02

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'htga/htga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# @author Cristhian Fuertes
# Main class for the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm
class CCHTGA < HTGA
  attr_reader :best_chromosome
  attr_reader :best_chromosomes_experiences

  # Method to perfom SNR calculation used in the CCHTGA
  # @param [Chromosome] chromosome, the chromosome
  # @return [void]
  def calculate_snr(chromosome)
    if @is_high_fit
      fail "CCHTGA's SNR calculation for maximization not implemented yet"
    else
      z = evaluate_chromosome chromosome
      chromosome.snr = (z - @best_chromosome.fitness)**-2
    end
  end
  # Mutation operator method for the chromosomes
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @return [Chromosome] the resulting mutated chromosome
  def mutate(chromosome, position)
    best_experience = @best_chromosomes_experiences[position]
    (0...@num_genes).each do |i|
      p = rand(0.0..1.0)
      r = rand(0.0..1.0)
      if p < 0.5
        chromosome[i] = @lower_bounds[i] + r * (@upper_bounds[i] -
                                                @lower_bounds[i])
      else
        chromosome[i] = chromosome[i] + (2 * r - 1) * (@best_chromosome[i] -
                                                       best_experience[i]).abs
      end
    end
  end
end
