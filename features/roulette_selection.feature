# language: en
# encoding: utf-8
# file: roulette_selection.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11
# last modified: 2015-15-11
# version: 0.2
# licence: GPL

Feature: Roulette selection operation
  @test_roulette_selection_positive_fitness
  Scenario: Test the roulette selection operation with positive fitness
    Given the fitness values of some chromosomes:
    |1|15|23|1|5|7|8|
    When I execute the roulette selection operation for maximization
    Then The calculated probabilities must be:
    |0.016666666666666666|0.26666666666666666|0.65|0.6666666666666666|0.75|0.8666666666666666|1.0|
