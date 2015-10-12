# !~/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require_relative 'chromosome'

# @author Cristhian Fuertes
# Main class for the Hybrid-Taguchi Genetic Algorithm
class HTGA
  attr_reader :chromosomes, :lower_bounds, :upper_bounds

  def initialize(**input)
    @values = input[:values]
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @pop_size = input[:pop_size]
    @cross_rate = input[:cross_rate]
    @mut_rate = input[:mut_rate]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuous = input[:continuous]
  end

  def start
  end

  def init_population
    (0...@pop_size).each do
      chromosome = Chromosome.new
      (0...@num_genes).each do |i|
        if @values == 'discrete'
          beta = rand(0..10) / 10.0
        elsif @values == 'uniform distribution'
          beta = rand(0..1000) / 1000.0
        end
        gene = @lower_bounds[i] + beta * (@upper_bounds[i] -
                                                 @lower_bounds[i])
        if @continuous
          chromosome << gene
        else
          chromosome << gene.round
        end
      end
      @chromosomes << chromosome
    end
  end

  # Inner class for roulette selection operation
  class Roulette
    # Normalizes an array that potentially contains negative numbers by shifting
    # all of them up to be positive (0 is left alone).
    #
    # +pop_fit+ array of each individual's fitness in a population to normalize
    def norm_pop(pop_fit)
      # Absolute value so can shift up
      # +1 so that it doesn't become 0
      least_fit = pop_fit.min.abs + 1

      pop_fit.map! do |f|
        (f != 0) ? (f + least_fit) : f
      end
      pop_fit
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
    def get_probs(pop_fit, is_high_fit = true)
      fit_sum  = 0.0 # Sum of each individual's fitness in the population
      prob_sum = 0.0 # You can think of this in 2 ways; either...
                     # 1) Current sum of each individual's probability in the
                     #    population
                     # or...
                     # 2) Last (most recently processed) individual's
                     # probability
                     # in the population

      probs    = []
      best_fit = nil # Only used if is_high_fit is false

      # Get fitness sum and best fitness
      pop_fit.each do |f|
        fit_sum += f
        best_fit = f if best_fit.nil? || f > best_fit
      end
      # puts "Best fitness: #{best_fit}"
      # puts "Fitness sum:  #{fit_sum}"
      best_fit += 1 # So that we don't get best_fit-best_fit=0
      # Get probabilities
      pop_fit.each_index do |i|
        f = pop_fit[i]
        if is_high_fit
          probs[i] = prob_sum + (f / fit_sum)
        else
          probs[i] = (f != 0) ? (prob_sum + ((best_fit - f) / fit_sum)) : 0.0
        end
        prob_sum = probs[i]
      end
      probs[probs.size - 1] = 1.0 # Ensure that the last individual is 1.0 due
                                  # to decimal problems in computers
                                  # (can be 0.99...)
      probs
    end

  end
end

if __FILE__ == $PROGRAM_NAME

end
