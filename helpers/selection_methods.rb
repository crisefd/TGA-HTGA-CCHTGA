# language: en
# encoding: utf-8
# file: roulette.rb
# author: Cristhian Fuertes & Oscar Tigreros
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11

require 'rubygems'
require 'bundler/setup'

# @author Cristhian Fuertes
# Module for Roulette Selection and SUS (Stochastic Universal Selection)
module Selection
  # Method that normalizes an array that potentially contains negative numbers
  # by shifting
  # all of them up to be positive (0 is left alone).
  # @param [Array<Chromosome>] chromosomes, list of chromosomes to normalize
  # @return [Array<Chromosome>] the normalized chromosomes
  def self.norm_pop(chromosomes)
    least_fit = (chromosomes.min_by(&:fitness)).fitness
    return false if !(least_fit < 0)
    chromosomes.map! do |chromosome|
      if chromosome.fitness != 0
        # @@flag = true
        chromosome.norm_fitness = chromosome.fitness - least_fit # Correct?
      end
      chromosome
    end
    return true
  end
end
