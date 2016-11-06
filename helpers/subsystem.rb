# language: english
# encoding: utf-8
# program: cchtga.rb
# creation date: 2016-04-04
# last modified: 2016-11-06

require_relative 'chromosome'

# Subsystem helper class for the CCHTGA
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class Subsystem < Array

  # @!attribute [Chromosome] best chromosome of subsystem
  attr_accessor :best_chromosome
  # @!attribute [Array<Chromosome>] population of chromosomes of the subsystem
  attr_accessor :chromosomes
  # @!attribute [Array<Chromosome>] the best experiences of each chromosome
  attr_accessor :best_chromosomes_experiences
  # @!attribute [Integer] the number of fitness evaluations
  attr_accessor :num_evaluations

  # Initialize the chromosomes and best chromosome's experiences
  # @param [Integer] pop_size
  # @param [Array<Chromosomes>] macro_cromosomes
  # @return [void]
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
