# language: en
# encoding: utf-8
# file: roulette.rb
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11
# last modified: 2015-15-11
# version: 0.2
# licence: GPL

require 'rubygems'
require 'bundler/setup'

# @author Cristhian Fuertes
# module for roulette selection operation
module Roulette
  # Normalizes an array that potentially contains negative numbers by shifting
  # all of them up to be positive (0 is left alone).
  #
  # +pop_fit+ array of each individual's fitness in a population to normalize
  def self.norm_pop(chromosomes)
    # Absolute value so can shift up
    # +1 so that it doesn't become 0

    least_fit = (chromosomes.min_by(&:fitness)).fitness.abs + 1
    chromosomes.map! do |chromosome|
      if chromosome.fitness != 0
        chromosome.fitness += least_fit
        chromosome
      else
        chromosome
      end
    end
  end

  # Returns an array of each individual's probability between 0.0 and 1.0
  # fitted
  # onto an imaginary roulette wheel (or pie).
  #
  # This will NOT work for negative fitness numbers, as a negative piece of a
  # pie
  # (i.e., roulette wheel) does not make sense.  Therefore, if you have
  # negative
  # numbers, you will have to normalize the population first before using
  # this.
  #
  # +pop_fit+ array of each individual's fitness in the population
  # +is_high_fit+ true if high fitness is best or false if low fitness is best
  def self.calc_probs(chromosomes, is_high_fit = true)
    fit_sum  = 0.0 # Sum of each individual's fitness in the population
    prob_sum = 0.0 # You can think of this in 2 ways; either...
                   # 1) Current sum of each individual's probability in the
                   #    population
                   # or...
                   # 2) Last (most recently processed) individual's
                   # probability
                   # in the population

    best_fit = nil # Only used if is_high_fit is false

    # Get fitness sum and best fitness
    chromosomes.each do |chromosome|
      fit_sum += chromosome.fitness
      if is_high_fit
        best_fit = chromosome.fitness if best_fit.nil? || chromosome.fitness > best_fit
      else
        best_fit = chromosome.fitness if best_fit.nil? || chromosome.fitness < best_fit
      end
    end

    best_fit += 1 # So that we don't get best_fit-best_fit=0

    # Get probabilities
    chromosomes.each_index do |i|
      f = chromosomes[i].fitness
      if is_high_fit
        chromosomes[i].prob = prob_sum + (f / fit_sum)
      else
        chromosomes[i].prob = (f != 0) ? (prob_sum + ((best_fit - f) / fit_sum)) : 0.0
      end
      prob_sum = chromosomes[i].prob
    end
    # Ensure that the last individual is 1.0
    chromosomes.last.prob = 1.0

  end

end
