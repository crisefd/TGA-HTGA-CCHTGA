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
        # @@flag = true
        chromosome.norm_fitness = chromosome.fitness + least_fit * -1 # Correct?
      end
      chromosome
    end
  end

  public

  # Compute an array of each individual's probability between 0.0 and 1.0
  # fitted
  # onto an imaginary roulette WHEEL (or pie).
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
  def self.calc_probs(chromosomes, is_high_fit: true, is_negative_fit: true) # rename to rws
    Selection.norm_pop chromosomes if is_negative_fit
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
      if is_negative_fit && !chromosome.norm_fitness.nil?
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
      prob_sum = chromosomes[i].prob
    end
    # Ensure that the last individual' probability is 1.0
    chromosomes.last.prob = 1.0
  end

  def self.sample(chromosomes, num_required_selects, is_high_fit: true, is_negative_fit: true) # rename to sus
    Selection.norm_pop chromosomes if is_negative_fit
    total_fit = chromosomes.map(&:fitness).inject(0, &:+)
    step_size = (total_fit / num_required_selects).to_i
    start = rand(0..step_size)
    pointers = []
    (0...num_required_selects).each do |i|
      ptr = start + (i * step_size)
      pointers << ptr
    end
    pointers
    # k = 0
    # pointers.each do |ptr|
    #   loop do
    #     fit_sum = chromosomes[0..k].map(&:fitness).inject(0, &:+)
    #     break if fit_sum >= ptr
    #     k += 1
    #   end
    # end
  end
end
