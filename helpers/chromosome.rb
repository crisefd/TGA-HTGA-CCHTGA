# language: en
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
  # @attr [Float] fitness, the fitness value for the chromosome
  attr_accessor :fitness
  # @attr [Float] prob, the probability value for the chromosome
  attr_accessor :prob
  # @attr [Float] snr_val, the value of the SNR
  attr_accessor :snr_val

  # Crossover operation method use in HTGA
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

  # Method to perfom SNR calculation used in the HTGA
  # @param [Chromosome] chromosome, the chromosome
  # @param [Boolean] smaller_the_better, true if SNR is for minization or false otherwise
  # @return [Float] the calculated SNR
  def self.snr(chromosome, smaller_the_better: true)
    n = chromosome.size
    if smaller_the_better
      chromosome.snr_val = -10 * Math.log10((1.0 / n) * chromosome.map { |gene| gene**2 }.reduce(:+))
    else
      chromosome.snr_val = -10 * Math.log10((1.0 / n) * chromosome.map { |gene| 1.0 / gene**2 }.reduce(:+))
    end
  end
end
