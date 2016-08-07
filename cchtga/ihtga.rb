# language: english
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-05-18

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'htga/htga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# @author Cristhian Fuertes
# Main class for the Improved Hybrid-Taguchi Genetic Algorithm
class IHTGA < HTGA
	# @!attribute [Chromosome] best_chromosome
	attr_writer :best_chromosome
	# @!attribute [Subsystem] subsystem
	attr_accessor :subsystem
	
	attr_writer :selected_func

	# @param [Hash] input, hash list for the initialization
	def initialize(**input)
		@beta_values = input[:beta_values]
		@upper_bounds = input[:upper_bounds]
		@lower_bounds = input[:lower_bounds]
		@pop_size = input[:pop_size]
		@cross_rate = input[:cross_rate]
		@mut_rate = input[:mut_rate]
		# @num_genes = input[:num_genes]
		@chromosomes = input[:chromosomes]
		@continuous = input[:continuous]
		input[:selected_func] = 0 if input[:selected_func].nil?
		@selected_func = input[:selected_func]
		@is_negative_fit = input[:is_negative_fit]
		@is_high_fit = input[:is_high_fit]
		@is_negative_fit = false if @is_negative_fit.nil?
		@is_high_fit = false if @is_high_fit.nil?
		@best_chromosome = nil
		@subsystem = input[:subsystem]
		@num_genes = @subsystem.size
		@subsystem.best_chromosomes_experiences = input[:chromosomes]
		@mutation_prob = input[:mutation_prob]
		@taguchi_array = input[:taguchi_array]
		@num_evaluations = 0 # how to calculate the number of evaluations for cchtga
		@subsystem.chromosomes = @chromosomes
		#find_best_chromosome
		
		# p "chromosomes #{@chromosomes[0].size}"
	end
	
	def find_best_chromosome
		@chromosomes.map! do |chromo|
			evaluate_chromosome chromo
			if @is_high_fit
        		@best_chromosome = chromo.clone if @best_chromosome.nil? ||
                		                           chromo.fitness >
                        		                   @best_chromosome.fitness
    		else
        		@best_chromosome = chromo.clone if @best_chromosome.nil? ||
                		                           chromo.fitness <
                        		                   @best_chromosome.fitness
    		end
    		chromo
	    end
	    @subsystem.best_chromosome = @best_chromosome
	    #p "subsys best chromo #{@best_chromosome}"
	    #a = gets.chomp
	end


	# Mutation operator
	# @param [Chromosome] chromosome
	# @param [Integer] position
	# @return [Chromosome]
	def mutate(chromosome, position)
		best_experience = @subsystem.best_chromosomes_experiences[position]
		(0...@num_genes).each do |i|
			p = rand(0..10) / 10.0
			r = rand(0..10) / 10.0
			if p < @mutation_prob
				chromosome[i] = @lower_bounds[i] + r * (@upper_bounds[i] -
														@lower_bounds[i])
			else
				chromosome[i] = chromosome[i] + (2 * r - 1) * (@best_chromosome[i] -
				best_experience[i]).abs
			end
		end
		chromosome
	end

	# Method to mutate the individuals according to a mutation rate
	# @return [void]
	def mutate_individuals
		# m = @chromosomes.size
		m = @pop_size
		(0...m).each do |x|
			r = rand 0.0..1.0
			next if r > @mut_rate
			new_chrom = mutate(@chromosomes[x].clone, x)
			evaluate_chromosome new_chrom
			@chromosomes << new_chrom
		end
	end

	# Method to cross individuals according to a crossover rate
	# @return [void]
	def cross_inviduals
		m = @chromosomes.size
		(0...m).each do |x|
			r = rand 0.0..1.0
			y = -1
			loop do
				y = rand 0...m
				break if x != y
			end
			next if r > @cross_rate
			new_chrom_x, new_chrom_y =
				crossover @chromosomes[x].clone, @chromosomes[y].clone
			evaluate_chromosome new_chrom_x
			evaluate_chromosome new_chrom_y
			@chromosomes << new_chrom_x << new_chrom_y
		end 
	end



	def execute
		
		find_best_chromosome
		
		cross_inviduals
		# p "individuals crossed"
		generate_offspring_by_taguchi_method
		# p "taguchi offspring generated"
		mutate_individuals
		# p "individuals mutated"
		@chromosomes = sus_select
		@subsystem.chromosomes = @chromosomes
		# p "sus selectection performed"
		@subsystem.num_evaluations = @num_evaluations
		fail "subsys chromosomes wrong #{@chromosomes.size} #{@subsystem.chromosomes.size}" if @chromosomes.size != @subsystem.chromosomes.size
	end


	# Method to perfom SNR calculation used in the CCHTGA
	# @param [Chromosome] chromosome, the chromosome
	# @return [void]
	def calculate_snr(chromosome)

		if @is_high_fit
			fail "CCHTGA's SNR calculation for maximization not implemented yet"
		else
			evaluate_chromosome chromosome
			# What if the rest equals zero ?
			chromosome.snr = (chromosome.fitness - @best_chromosome.fitness)**-2
		end
	end
end
