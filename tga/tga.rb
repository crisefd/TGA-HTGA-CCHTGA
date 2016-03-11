# language: english
# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 07-03-2015

require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), '..', 'base_ga/base_ga.rb')
require File.join(File.dirname(__FILE__), '..', 'helpers/chromosome.rb')

# @author Oscar Tigreros

class TGA < BaseGA

  def initialize(**input)
    @values = input[:values]
    @pop_sizes = input[:pop_sizes]
    p "población "
    p @pop_sizes
    @upper_bounds = input[:upper_bounds]
    @lower_bounds = input[:lower_bounds]
    @num_genes = input[:num_genes]
    @chromosomes = []
    @continuos = input[:continuos]
    input[:selected_func] = 0 if input[:selected_func].nil?
    @selected_func = TEST_FUNCTIONS[input[:selected_func] - 1]
    @is_negative_fit = input[:is_negative_fit]
    @is_high_fit = input[:is_high_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = false if @is_high_fit.nil?
    @max_generation = input[:max_generation]
    @mating_pool = []
    @new_gen = []
    @num_evaluations = 0

  end

  #Main methon for TGA


  def execute

    @generation = 1
    best_fit = nil
    init_time = Time.now
    begin
      init_population

      #while @generation <= @max_generation
        tournament
        #mutate_matingpool
        cross_mating_pool
      #end
      #break if @chromosomes.first.fitness == @optimal_func_val
      #@generation += 1
    end
  end

#Method to select chromosomes by tournamet default  k=2
# @return [void]
=begin
  def tournamentb
    if 2 < 3
      p 3
    else
      p 2
    end
  end
=end



# @return [void]
  def tournament
    k = 2
    temp_k = k

    x = -1
    y = -1
    prev_chromo = -1
    loop do
      temp_k -= 1
      loop do
          x = rand(0...chromosomes.size)
          y = rand(0...chromosomes.size)
          break if x != y
        end
        if ((@chromosomes[x].fitness < @chromosomes[y].fitness) && (y != prev_chromo))
          @mating_pool << @chromosomes[y]
          prev_chromo = y
        elsif((@chromosomes[y].fitness < @chromosomes[x].fitness) && (x != prev_chromo))
          @mating_pool << @chromosomes[x]
          prev_chromo = x
        else
          if (temp_k += 1) > k
            temp_k = k
          else
            temp_k += 1
          end
        end
      break if temp_k <= 0
    end
#    p @mating_pool
  end



  #uniform cross 1 gen
  def cross_mating_pool
    cut_point = rand(0...@num_genes)
    chromosome_x = @mating_pool[0]
    chromosome_y = @mating_pool[1]
    gen_x = chromosome_x[cut_point]
    gen_y = chromosome_y[cut_point]
    chromosome_x[cut_point] = gen_y
    chromosome_y[cut_point] = gen_x
  end

  #uniform cross 1 cut point
  def cross_cut_point_mating_pool
    cut_point = rand(0...@num_genes)
    chromosome_x = @mating_pool[0]
    chromosome_y = @mating_pool[1]
    temp_cut_x = -1
    temp_cut_y = -1
    (cut_point...@num_genes).each do |i|
      temp_cut_x = chromosome_x[i]
      temp_cut_y = chromosome_y[i]
      chromosome_x[i] = temp_cut_y
      chromosome_y[i] = temp_cut_x
    end
    @new_gen << chromosome_y
    @new_gen << chromosome_x
  end
  #TO DO HERE
  def mutate_matingpool
    mutate_point = rand(0...@num_genes)


  end
  def insert_new_generation

  end
  def recalculate_fitness
    @chromosomes.map! do |chromosome|
      chromosome.fitness = @selected_func.call chromosome
      chromosome
    end
  end

#TO DO END HERE





end
if __FILE__ == $PROGRAM_NAME
  dim = 30
  bound = 1.28
  tga = TGA.new values: 'discrete',
                upper_bounds: Array.new(dim, bound),
                lower_bounds: Array.new(dim, -1 * bound),
                pop_sizes: 200,
                #cross_rate: 0.1,
                #mut_rate: 0.02,
                num_genes: dim,
                continuous: true,
                selected_func: 12,
                is_negative_fit: false,
                is_high_fit: false,
                max_generation: 1000
  tga.execute
end
