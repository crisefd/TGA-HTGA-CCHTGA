# language: en
# encoding: utf-8
# file: roulette.rb
# author: Cristhian Fuertes & Oscar Tigreros
# email:  cristhian.fuertes@correounivalle.edu.co
<<<<<<< HEAD
# creation date: 2016-04-24
=======
# creation date: 2015-15-11
>>>>>>> f6654c7f463625b3e65a66065742c62505ba4149

require 'rubygems'
require 'bundler/setup'
require_relative 'selection_methods'

# @author Cristhian Fuertes
module Selection::SUS
    def self.sample(chromosomes, num_required_selects, is_high_fit: true,
                                                       is_negative_fit: true) # rename to sus
        Selection.norm_pop chromosomes if is_negative_fit
        fit_sum = 0
        chromosomes.each do |chromosome|
            if is_negative_fit && !chromosome.norm_fitness.nil?
                fit_sum += chromosome.norm_fitness
            else
                fit_sum += chromosome.fitness
            end
            chromosome.fit_sum = fit_sum
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
