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

  attr_accessor :selected_func

  attr_writer :is_high_fit

  attr_reader :generation

  attr_writer :max_generation

  # @attr [Random] ran, variable for generation of random numbers
  @ran = Random.new

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
  def roulette_select
    p "=> roulette selection"
    @ran = Random.new
    Roulette.calc_probs @chromosomes, is_high_fit: @is_high_fit,
                                  is_negative_fit: @is_negative_fit
    copied_chromosomes = @chromosomes.clone and @chromosomes.clear
    (0...@pop_size).each do
      r = @ran.rand(1.0)
      copied_chromosomes.each_index do |i|
        @chromosomes << copied_chromosomes[i] if r < copied_chromosomes[i].prob
      end
    end
  end
end
