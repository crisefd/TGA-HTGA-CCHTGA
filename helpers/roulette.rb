# language: en
# encoding: utf-8
# file: roulette.rb
# creation date: 2015-11-15
# las modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'

# Helper  module for the roulette selection
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
module Roulette

  # Calculates the probabilities for the chromosomes
  # @param [Array] chromosomes
  # @param [Bool] is_high_fit
  # @return [void]
  # @note the second parameter is unused, should be deprecated soon
  def self.calculate_probabilities(chromosomes, is_high_fit: true)
    minmax_chromos = (chromosomes.minmax_by(&:fitness))
    min_fit, max_fit = minmax_chromos[0].fitness, minmax_chromos[1].fitness
    fit_sum = 0.0
    prob_sum = 0
    fit_factor = 1.0
    max_fit += 1
    base = max_fit + fit_factor * (max_fit - min_fit)
    chromosomes.map! do |chromosome|
      chromosome.norm_fitness = (base) - chromosome.fitness
      fit_sum += chromosome.norm_fitness
      chromosome
    end
    chromosomes.map! do |chromosome|
      f = chromosome.norm_fitness
      chromosome.prob = prob_sum + (f / fit_sum)
      if chromosome.prob.nan?
        p "f=#{f} fit_sum=#{fit_sum} base=#{base} max_fit=#{max_fit} min_fit=#{min_fit} prob_sum=#{prob_sum}"
        fail "NAN "
      end
      prob_sum = chromosome.prob
      chromosome
    end
    chromosomes.last.prob = 1.0
  end

end
