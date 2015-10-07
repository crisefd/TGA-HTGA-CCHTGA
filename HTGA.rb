require 'rubygems'
require 'bundler/setup'
require_relative 'chromosome'
class HTGA < Array
  def initialize(**input)
     @values = Array.new input[:values]
     @upper_bounds = input[:upper_bounds]
     @lower_bounds = input[:lower_bounds]
     @pop_size = input[:pop_size]
     @cross_rate = input[:cross_rate]
     @mut_rate = input[:mut_rate]
     @num_genes = input[:num_genes]
  end

  def start

  end

  def init_population
    beta = @values[rand(0...@values.size)]
    (0...@pop_size).each do
      crom = Chromosome.new
      (0...@num_genes).each do |i|
        crom << @lower_bounds[i] + beta * (@upper_bounds[i] - @lower_bounds)
      end
      self << crom
    end

  end
end

if __FILE__ == $PROGRAM_NAME

end
