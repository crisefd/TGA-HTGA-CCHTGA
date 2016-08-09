# language: en
# encoding: utf-8
# file: roulette.rb
# author: Cristhian Fuertes & Oscar Tigreros
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-24


require 'rubygems'
require 'bundler/setup'

# @author Cristhian Fuertes
module SUS
  def self.sample(chromosomes, num_required_selects, is_high_fit: true,
                                                     is_negative_fit: true)
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
