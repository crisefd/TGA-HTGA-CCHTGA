# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-07
# last modified: 2015-10-07
# version: 0.2
# licence: GPL

Feature: initial population test

  @test_discrete_genes
  Scenario: Test generation of discrete genes
    Given a population size of 20
    And a number of genes of 10
    And the upper bounds are |15|15|15|15|15|15|15|15|15|15|
    And the lower bounds are |-5|-5|-5|-5|-5|-5|-5|-5|-5|-5|
    And the list of values is |0|0.1| 0.2| 0.3| 0.4| 0.5| 0.6| 0.7| 0.8| 0.9| 1|
    When I create  the chromosomes
    Then all of theirs values,the genes, must be integer numbers between their corresponding upper and lower bounds
