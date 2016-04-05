# language: en
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes & Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05


require 'rubygems'
require 'bundler/setup'

# Chromosome class for TGA, HTGA & CCHTGA
# @author Cristhian Fuertes
# @author Oscar Tigreros
class Chromosome < Array
  # @attr [Float] fitness, the fitness value for the chromosome
  attr_accessor :fitness
  # @attr [Float] norm_fitness, the normalized fitness value fo the chromosome
  attr_accessor :norm_fitness
  # @attr [Float] prob, the probability value for the chromosome
  attr_accessor :prob
  # @attr [Float] snr, the value of the SNR
  attr_accessor :snr
end
