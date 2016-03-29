# language: en
# encoding: utf-8
# file: roulette.rb
# author: Cristhian Fuertes & Oscar Tigreros
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11

require 'rubygems'
require 'bundler/setup'

# @author Cristhian Fuertes
# Module for roulette selection operation
module Roulette
  @@flag = false
  private

  # Method that normalizes an array that potentially contains negative numbers
  # by shifting
  # all of them up to be positive (0 is left alone).
  # @param [Array<Chromosome>] chromosomes, list of chromosomes to normalize
  # @return [Array<Chromosome>] the normalized chromosomes
  def self.norm_pop(chromosomes)
    least_fit = (chromosomes.min_by(&:fitness)).fitness
    chromosomes.map! do |chromosome|
      if chromosome.fitness != 0
        @@flag = true
        chromosome.norm_fitness = chromosome.fitness + least_fit * -1 # Correct?
      end
      chromosome
    end
  end

  public

  # Compute an array of each individual's probability between 0.0 and 1.0
  # fitted
  # onto an imaginary roulette wheel (or pie).
  #
  # This will NOT work for negative fitness numbers, as a negative piece of a
  # pie
  # (i.e., roulette wheel) does not make sense.  Therefore, if you have
  # negative
  # numbers, you will have to normalize the population first before using
  # this.
  # @param [Array<Chromosome>] chromosomes, list of chromosomes
  # @param [Boolean] is_high_fit, true if high fitness is best or false if low fitness is best
  # @param [Boolean] is_negative_fit, true if there are negative fitness and false otherwise
  # @return [void]
  def self.calc_probs(chromosomes, is_high_fit: true, is_negative_fit: true)
    @@flag = false
    Roulette.norm_pop chromosomes if is_negative_fit
    fit_sum  = 0.0 # Sum of each individual's fitness in the population
    prob_sum = 0.0 # You can think of this in 2 ways; either...
                   # 1) Current sum of each individual's probability in the
                   #    population
                   # or...
                   # 2) Last (most recently processed) individual's
                   # probability
                   # in the population

    max_fit = nil # use only  for minimization (is_high_fit=false)

    # Get fitness sum and maximum fitness
    chromosomes.each do |chromosome|
      fail 'nil fit_sum' unless !fit_sum.nil?
      if is_negative_fit
        fail "nil norm_fitness. Flag #{@@flag}" unless !chromosome.norm_fitness.nil?
        fit_sum += chromosome.norm_fitness
        max_fit = chromosome.norm_fitness if max_fit.nil? || chromosome.norm_fitness > max_fit
      else
        fit_sum += chromosome.fitness
        max_fit = chromosome.fitness if max_fit.nil? || chromosome.fitness > max_fit
      end

    end

    max_fit += 1 # So that we don't get max_fit=0

    # Get probabilities
    chromosomes.each_index do |i|
      if is_negative_fit
        f = chromosomes[i].norm_fitness
        if is_high_fit
          chromosomes[i].prob = prob_sum + (f / fit_sum)
        else
          chromosomes[i].prob = (f != 0) ? (prob_sum + ((max_fit - f) / fit_sum)) : 0.0
        end
      else
        f = chromosomes[i].fitness
        if is_high_fit
          chromosomes[i].prob = prob_sum + (f / fit_sum)
        else
          chromosomes[i].prob = (f != 0) ? (prob_sum + ((max_fit - f) / fit_sum)) : 0.0
        end
      end
      fail "negative probability #{chromosomes[i].prob} max_fit #{max_fit} f #{f} fit_sum #{fit_sum} prob_sum #{prob_sum}" unless chromosomes[i].prob >= 0
      prob_sum = chromosomes[i].prob
    end
    # Ensure that the last individual' probability is 1.0
    chromosomes.last.prob = 1.0

  end

end
