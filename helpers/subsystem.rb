# language: english
# program: cchtga.rb
# creation date: 2016-04-04
# last modified: 2016-11-06

require_relative 'chromosome'

# Subsystem helper class for the CCHTGA
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class Subsystem < Array

  # @!attribute best_chromosome
  #	@return [Chromosome] The best chromosome of the subsysmte
  attr_accessor :best_chromosome
  # @!attribute chromosomes
  #	@return [Array<Chromosome>] population of chromosomes of the subsystem
  attr_accessor :chromosomes
  # @!attribute best_chromosomes_experiences
  #	@return [Array<Chromosome>] The best experiences of each chromosome
  attr_accessor :best_chromosomes_experiences
  # @!attribute num_evaluations
  #	@return [Integer] The number of fitness evaluations of the subsystem
  attr_accessor :num_evaluations

  # Initialize the chromosomes and best chromosome's experiences
  # @param [Integer] pop_size The number of chromosomes in the population
  # @param [Array<Chromosomes>] macro_cromosomes The original population of chromosomes
  # @return [nil]
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
