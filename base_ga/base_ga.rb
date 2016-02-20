# encoding: utf-8
# Program: htga.rb
# Authors: Cristhian Fuertes
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-05

require 'rubygems'
require 'bundler/setup'
Dir[File.dirname(__FILE__) + './../helpers/*.rb'].each do |file|
 require File.basename(file, File.extname(file))
end

# @author Cristhian Fuertes
# Base class for genetic algorithms
class BaseGA
  include Roulette, TestFunctions

  attr_reader :lower_bounds, :upper_bounds
  attr_writer :pop_size
  attr_accessor :chromosomes
  $ran = Random.new

  def initialize(**input)
    @chromosomes = input[:chromosomes]
    @pop_size = input[:pop_size]
    @is_negative_fit = input[:is_negative_fit]
    @is_negative_fit = false if @is_negative_fit.nil?
    @is_high_fit = input[:is_high_fit]
    @is_high_fit = false if @is_high_fit.nil?
  end

  def roulette_select
    Roulette.calc_probs @chromosomes, is_high_fit: @is_high_fit,
                        is_negative_fit: @is_negative_fit
    copied_chromosomes = @chromosomes.clone and @chromosomes.clear
    (0...@pop_size).each do
      r = $ran.rand(1.0)
      copied_chromosomes.each_index do |i|
        @chromosomes << copied_chromosomes[i] if r < copied_chromosomes[i].prob
      end
    end
  end

end
