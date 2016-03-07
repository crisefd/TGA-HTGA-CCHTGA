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

@author Oscar Tigreros

class TGA << BaseGA

  def initialize(**input)
    @values = input[:values]
    @pop_sizes = input[:pop_sizes]
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
    @num_evaluations = 0
  end

  #Main methon for TGA


  def execute

    @generation = 1
    best_fit = nil
    init_time = Time.now
    begin
      init_population
    end
  end

#Method to generate the initial population
#@rertun [void]
  def ama

    end
