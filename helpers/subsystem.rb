# language: english
# encoding: utf-8
# Program: cchtga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-04-04

require_relative 'chromosome'

# Class for subsystems in the CCHTGA
class Subsystem < Array
  
  # @!attribute [Chromosome] best chromosome of subsystem
  attr_accessor :best_chromosome
  # @!attribute [Array<Chromosome>] population of chromosomes of the subsystem
  attr_accessor :chromosomes
  # @!attribute [Array<Chromosome>] the best experiences of each chromosome
  attr_accessor :best_chromosomes_experiences
  
  attr_accessor :num_evaluations
  
  # def initialize(**args)
  #   super **args
  #   @best_chromosome = Chromosome.new
  #   @chromosomes = []
  #   @best_chromosomes_experiences = []
  #   @num_evaluations = 0
  # end
  
  def init_chromosomes(pop_size, macro_cromosomes)
    (0...pop_size).each do |j|
      chromo = Chromosome.new
      each do |gene|
        chromo << macro_cromosomes[j][gene]
      end
      @chromosomes << chromo
    end
    @best_chromosomes_experiences = @chromosomes.clone
  end  
end
