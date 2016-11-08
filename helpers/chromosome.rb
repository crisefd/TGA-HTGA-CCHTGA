# language: en
# encoding: utf-8
# program: htga.rb
# creation date: 2015-10-05
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'

# Helper class for coding solution in genetic algorithms
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class Chromosome < Array

  # @!attribute fitness
  #	@return [Float] The fitness value for the chromosome
  attr_accessor :fitness
  # @!attribute [Float] norm_fitness
  #	@return [Float] The normalized fitness value of the chromosome
  attr_accessor :norm_fitness
  # @!attribute prob
  #	@return [Float] The probability value for the chromosome
  attr_accessor :prob
  # @!attribute snr
  #	@return [Float] The SNR value
  attr_accessor :snr
  # @!attribute fit_sum
  #	@return [Float] The accumulated fitness
  attr_accessor :fit_sum

end
