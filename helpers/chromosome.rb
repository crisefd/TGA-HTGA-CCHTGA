require 'rubygems'
require 'bundler/setup'

# Chromosome class for Hybrid-Taguchi Genetic Algorithm
class Chromosome < Array
  attr_accessor :fitness, :prob

  def self.crossover **args
    chromosome_x = args[:chromosome_x]
    chromosome_y = args[:chromosome_y]
    beta = rand(0..10) / 10.0
    k = rand(0...chromosome_y.size)
    upper_bounds = args[:upper_bounds]
    lower_bounds = args[:lower_bounds]
    # new values for kth genes x and y
    cut_point_x = chromosome_x[k]
    cut_point_y = chromosome_y[k]
    cut_point_x = cut_point_x + beta * (cut_point_y - cut_point_x)
    cut_point_y = lower_bounds[k] + beta * (upper_bounds[k] - lower_bounds[k])
    chromosome_x[k] = cut_point_x
    chromosome_y[k] = cut_point_y
    # swap right side of chromosomes x and y
    ((k + 1)...chromosome_y.size).each do |i|
      chromosome_x[i], chromosome_y[i] = chromosome_y[i], chromosome_x[i]
    end
    return chromosome_x, chromosome_y
  end

  def self.mutate(chromosome)
    beta = rand(0..10) / 10.0
    i = -1
    k = -1
    loop do
      i = rand(0...chromosome.size)
      k = rand(0...chromosome.size)
      break if i != k
    end
    gene_i = chromosome[i]
    gene_k = chromosome[k]
    chromosome[i] = (1 - beta) * gene_i + beta * gene_k
    chromosome[k] = beta * gene_i + (1 - beta) * gene_k
    chromosome
  end
end
=begin
if __FILE__ == $PROGRAM_NAME
  c1 = Chromosome.new [-5, 3, 4.5]
  c2 = Chromosome.new [0,1,5]
  c3 = Chromosome.new [-1,-2, 1]
  c4 = Chromosome.new [1,3,-5]
  c5 = Chromosome.new [5,4,0]
  c1 = mutate(c1.clone)
  c2 = mutate(c2.clone)
  c3 = mutate(c3.clone)
  c4 = mutate(c4.clone)
  c5 = mutate(c5.clone)
  p c1
  p c2
  p c3
  p c4
  p c5
end
=end
