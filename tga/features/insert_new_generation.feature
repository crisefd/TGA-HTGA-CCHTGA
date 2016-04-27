# language: en
# encoding: utf-8
# file: init_population.feature
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-04-21
# last modified:
# version: 0.2
# licence: GPL

Feature: insert new generation
  @test_new_generation

  Scenario: Test the insert new generation operation
    Given the chromosomes :
    #|chromosome x|chromosome y|chromosome w|chromosome z|
    |1|0|0|2|
    |1|0|1|0|
    |1|3|0|1|
    |0|1|1|1|

    When new generation is inserted
    Then the population size, most kept the same size. With the new chromosomes.
