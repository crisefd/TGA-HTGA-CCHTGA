# language: en
# encoding: utf-8
# file: roulette.rb
# creation date: 2016-04-24
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'

# Helper module for the stochastic universal sampling selection
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
module SUS

  # Calculates the pointers for the selection of the chromosomes
  # @param [Array<Chromosome>] chromosomes
  # @param [Integer] num_required_selects
  # @param [Bool] is_high_fit
  # @param [Bool] is_negative_fit
  # @return [Array]
  # @note The third and fourth parameters are unused, should be deprecated soon
  def self.sample(chromosomes, num_required_selects, is_high_fit: true,
                                                     is_negative_fit: true)
    minmax_chromos = (chromosomes.minmax_by(&:fitness))
    min_fit, max_fit = minmax_chromos[0].fitness, minmax_chromos[1].fitness
    fit_sum = 0.0
    fit_factor = 1.0
    max_fit += 1
    base = max_fit + fit_factor * (max_fit - min_fit)
    chromosomes.map! do |chromosome|
      chromosome.norm_fitness = (base) - chromosome.fitness
      fit_sum += chromosome.norm_fitness
      chromosome.fit_sum = fit_sum
      chromosome
    end
    step_size = (fit_sum / num_required_selects).to_i
    start = rand(0..step_size)
    pointers = []
    (0...num_required_selects).each do |i|
      ptr = start + (i * step_size)
      pointers << ptr
    end
    pointers
  end

end
