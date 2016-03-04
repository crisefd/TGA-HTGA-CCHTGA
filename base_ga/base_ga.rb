# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes & Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'helpers/roulette.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/test_functions.rb')

# @author Cristhian Fuertes
# @author Oscar Tigreros
# Mixin class for TGA, HTGA & CCHTGA
class BaseGA
  # Modules for roulette selection operation and test functions
  include Roulette, TestFunctions

  # @attr [Array] lower_bounds, lower bounds for the variables
  attr_reader :lower_bounds
  # @attr [Array] upper_bounds, upper bounds for the variables
  attr_reader :upper_bounds
  # @attr [Array] pop_size, the number of chromosomes
  attr_writer :pop_size
  # @attr [Array] chromosomes, the candidate solutions
  attr_accessor :chromosomes
  # @attr [Proc] selected_func, the selected function to optimize
  attr_writer :selected_func
  # @attr [Boolean] is_high_fit, a flag indicating if what is sought is a high fitness
  attr_writer :is_high_fit
  # @attr [Integer] generation, the counting variables of the number of generations
  attr_reader :generation
  # @attr [Integer] max_generation, the maximum allow number of generations
  attr_writer :max_generation
  # @attr [Integer] num_genes, the length of the chromosomes
  attr_accessor :num_genes

  # @param [Hash] input, hash list for construction parameters
  def initialize(**input)
    @chromosomes = input[:chromosomes]
    @pop_size = input[:pop_size]
    @is_negative_fit = input[:is_negative_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = input[:is_high_fit]
    @is_high_fit = false if @is_high_fit.nil?
  end

  # Roulette selection operation method
  # @return [void]
  def roulette_select # This method can be optimize
    pp '=> roulette selection'
    fail "pop size incorrect, expected #{pop_size} found #{@chromosomes.size}" unless @pop_size == @chromosomes.size
    Roulette.calc_probs @chromosomes, is_high_fit: @is_high_fit,
                                      is_negative_fit: @is_negative_fit
    copied_chromosomes = @chromosomes.clone and @chromosomes.clear
    r = Random.rand(1.0)
    rejected_chromosomes = []
    (0...@pop_size).each do |i|
      if r < copied_chromosomes[i].prob # This validation here, can be optimize
        @chromosomes << copied_chromosomes[i]
      else
        rejected_chromosomes << copied_chromosomes[i]
      end
    end
    fail "pop size after selection incorrect, expected #{@chromosomes.size} <= #{pop_size}" unless @pop_size >= @chromosomes.size
    selected_offset = @chromosomes.size
    @chromosomes += rejected_chromosomes.reverse!
    selected_offset
  end
end
