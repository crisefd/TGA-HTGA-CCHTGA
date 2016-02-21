# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes & Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'

# Chromosome class for TGA, HTGA & CCHTGA
# @author Cristhian Fuertes
# @author Oscar Tigreros
class Chromosome < Array

  # @attr [Double] fitness, the fitness value for the chromosome
  attr_accessor :fitness
  # @attr [Double] prob, the probability value for the chromosome
  attr_accessor :prob

  # Crossover operation method for chromosomes
  # @param [Hash] args, argument hash list that includes chromosomes, lower and upper bounds
  # @return [Chromosome, Chromosome]  the resulting chromosomes.
  def self.crossover(**args)
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
    chromosome_x[k] = cut_point_x
    chromosome_y[k] = cut_point_y
    # swap right side of chromosomes x and y
    ((k + 1)...chromosome_y.size).each do |i|
      chromosome_x[i], chromosome_y[i] = chromosome_y[i], chromosome_x[i]
    end
    return chromosome_x, chromosome_y
  end

  # Mutation operation method for the chromosomes
  # @param [Chromosome] chromosome, the chromosome to mutate
  # @return [Chromosome] the resulting chrmosome
  def self.mutate(chromosome)
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
    chromosome[i] = (1 - beta) * gene_i + beta * gene_k
    chromosome[k] = beta * gene_i + (1 - beta) * gene_k
    chromosome
  end
end
=begin
if __FILE__ == $PROGRAM_NAME
  c1 = Chromosome.new [-5, 3, 4.5]
  c2 = Chromosome.new [0,1,5]
  c3 = Chromosome.new [-1,-2, 1]
  c4 = Chromosome.new [1,3,-5]
  c5 = Chromosome.new [5,4,0]
  c1 = mutate(c1.clone)
  c2 = mutate(c2.clone)
  c3 = mutate(c3.clone)
  c4 = mutate(c4.clone)
  c5 = mutate(c5.clone)
  p c1
  p c2
  p c3
  p c4
  p c5
end
=end
