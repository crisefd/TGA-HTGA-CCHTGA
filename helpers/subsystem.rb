# language: english
# encoding: utf-8
# Program: cchtga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-04-04

# require 'set'
require_relative 'chromosome'

# Class for subsystems in the CCHTGA
class Subsystem < Array
 # attr_accessor :best_chromosome
  attr_accessor :best_chromosomes_experiences
end
