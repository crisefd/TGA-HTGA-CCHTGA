# language: en
# encoding: utf-8
# file: roulette_selection.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11

Feature: Roulette selection operation
  @test_roulette_selection_positive_fitness
  Scenario: Test the roulette selection operation with positive fitness
    Given the positive fitness values of some chromosomes:
    |1|15|23|1|5|7|8|
    When I execute the roulette selection operation for maximization of positive fitness values
    Then The calculated probabilities must be:
    |0.016666666666666666|0.26666666666666666|0.65|0.6666666666666666|0.75|0.8666666666666666|1.0|

  @test_roulette_selection_negative_fitness
  Scenario: Test the roulette selection operation with negative fitness
    Given the negative fitness values of some chromosomes:
    |-1|-15|-23|-1|-5|-7|-8|
    When I execute the roulette selection operation for maximization of negative fitness values
    Then The calculated probabilities must be:
    |0.21296296296296297|0.2962962962962963|0.3055555555555555|0.5185185185185185|0.6944444444444444|0.8518518518518519|1.0|
