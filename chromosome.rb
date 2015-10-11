require 'rubygems'
require 'bundler/setup'

# Chromosome class for HTGA
class Chromosome < Array
  def self.crossover(**args)
    chromosome_x = args[:chromosome_x]
    chromosome_y = args[:chromosome_y]
    beta = args[:beta]
    k = args[:k]
    upper_bound = args[:upper_bound]
    lower_bound = args[:lower_bound]
    # new values for kth genes x and y
    cut_point_x = chromosome_x[k]
    cut_point_y = chromosome_y[k]
    cut_point_x = cut_point_x + beta * (cut_point_y - cut_point_x)
    cut_point_y = lower_bound + beta * (upper_bound - lower_bound)
    chromosome_x[k] = cut_point_x
    chromosome_y[k] = cut_point_y
    # swap right side of chromosomes x and y
    ((k + 1)...chromosome_y.size).each do |i|
      chromosome_x[i], chromosome_y[i] = chromosome_y[i], chromosome_x[i]
    end
    return chromosome_x, chromosome_y
  end

  def self.mutate(**args)
    beta = args[:beta]
    i = args[:i]
    k = args[:k]
    chromosome = args[:chromosome]
    gene_i = chromosome[i]
    gene_k = chromosome[k]
    chromosome[i] = (1 - beta) * gene_i + beta * gene_k
    chromosome[k] = beta * gene_i + (1 - beta) * gene_k
    chromosome
  end
end
