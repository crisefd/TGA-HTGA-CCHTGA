# language: en
# encoding: utf-8
# program: htga.rb
# creation date: 2015-10-05
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'

# Chromosome helper class for genetic algorithms
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class Chromosome < Array

  # @!attribute [Float] fitness, the fitness value for the chromosome
  attr_accessor :fitness
  # @!attribute [Float] norm_fitness, the normalized fitness value fo the chromosome
  attr_accessor :norm_fitness
  # @!attribute [Float] prob, the probability value for the chromosome
  attr_accessor :prob
  # @!attribute [Float] snr, the value of the SNR
  attr_accessor :snr
  # @!attribute [Float] fit_sum, accumulated fitness
  attr_accessor :fit_sum

end