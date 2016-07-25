# language: en
# encoding: utf-8
# file: roulette.rb
# author: Cristhian Fuertes & Oscar Tigreros
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11

require 'rubygems'
require 'bundler/setup'

# @author Cristhian Fuertes
module Roulette

  def self.calculate_probabilities(chromosomes, is_high_fit: true)
    minmax_chromos = (chromosomes.minmax_by(&:fitness))
    min_fit, max_fit = minmax_chromos[0].fitness, minmax_chromos[1].fitness
    fit_sum = 0.0
    prob_sum = 0
    fit_factor = 1.0
    max_fit += 1
    base = max_fit + fit_factor * (max_fit - min_fit)
    # p "base = #{base}"
    chromosomes.map! do |chromosome|
        chromosome.norm_fitness = (base) - chromosome.fitness
        # chromosome.norm_fitness = chromosome.fitness - min_fit
        fit_sum += chromosome.norm_fitness
        chromosome
    end
    # "fit_sum = #{fit_sum}"
    chromosomes.map! do |chromosome|
      f = chromosome.norm_fitness
      chromosome.prob = prob_sum + (f / fit_sum)
      if chromosome.prob.nan?
        p "f=#{f} fit_sum=#{fit_sum} base=#{base} max_fit=#{max_fit} min_fit=#{min_fit} prob_sum=#{prob_sum}"
        fail "NAN "
      end
      # p "prob = #{chromosome.prob} prob_sum=#{prob_sum}"
      prob_sum = chromosome.prob
      chromosome
    end
    chromosomes.last.prob = 1.0
  end



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
  #def self.calc_probs(chromosomes, is_high_fit: true, is_negative_fit: true) # rename to rws
  #  Selection::norm_pop chromosomes if is_negative_fit
  #  fit_sum  = 0.0 # Sum of each individual's fitness in the population
  #  prob_sum = 0.0 # You can think of this in 2 ways; either...
  #  # 1) Current sum of each individual's probability in the
  #  #    population
  #  # or...
  #  # 2) Last (most recently processed) individual's
  #  # probability
  #  # in the population

  #   max_fit = nil # use only  for minimization (is_high_fit=false)

  #   # Get fitness sum and maximum fitness
  #   chromosomes.each do |chromosome|
  #     if is_negative_fit && !chromosome.norm_fitness.nil?
  #       fit_sum += chromosome.norm_fitness
  #       max_fit = chromosome.norm_fitness if max_fit.nil? || chromosome.norm_fitness > max_fit
  #     else
  #       fit_sum += chromosome.fitness
  #       max_fit = chromosome.fitness if max_fit.nil? || chromosome.fitness > max_fit
  #     end
  #   end

  #   max_fit += 1 # So that we don't get max_fit=0

  #   # Get probabilities
  #   chromosomes.each_index do |i|
  #     if is_negative_fit && !chromosomes[i].norm_fitness.nil?
  #       f = chromosomes[i].norm_fitness
  #       if is_high_fit
  #         chromosomes[i].prob = prob_sum + (f / fit_sum)
  #       else
  #         chromosomes[i].prob = (f != 0) ? (prob_sum + ((max_fit - f) / fit_sum)) : 0.0
  #       end
  #     else
  #       f = chromosomes[i].fitness
  #       if is_high_fit
  #         chromosomes[i].prob = prob_sum + (f / fit_sum)
  #       else
  #         chromosomes[i].prob = (f != 0) ? (prob_sum + ((max_fit - f) / fit_sum)) : 0.0
  #       end
  #     end
  #     prob_sum = chromosomes[i].prob
  #   end
  #   # Ensure that the last individual' probability is 1.0
  #   chromosomes.last.prob = 1.0
  # end
end
