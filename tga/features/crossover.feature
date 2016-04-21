# language: en
# encoding: utf-8
# file: init_population.feature
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-04-21
# last modified:
# version: 0.2
# licence: GPL

Feature: Crossover operation
  @test_crossover
  Scenario: Test the crossover operation
    Given the chromosomes:
    #|chromosome x|chromosome y|
    |1|0|
    |1|0|
    |-1|3|
    |0|1|

    When crossover is apply on the mating pool
    Then the crossover chromosome changes on one gene
