# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-11
# last modified: 2015-10-11
# version: 0.2
# licence: GPL

Feature: Crossover operation
  @test_crossover_non_cotinuous
  Scenario: Test crossover between two chromosomes with non continuous variables using arithmetic operator derived from convex set theory
    Given the chromosomes:
    |chromosome x|chromosome y|
    |1|0|
    |1|0|
    |-1|3|
    |0|1|
    |1|0|
    |1|0|
    |1|0|
    When I apply crossover with a beta value of "0.5"
    And a k value of 2
    And an upper bound value of "5"
    And a lower bound value of "-5"
    Then the resulting chromosomes must be:
    |chromosome x|chromosome y|
    |1|0|
    |1|0|
    |1|0|
    |1|0|
    |0|1|
    |0|1|
    |0|1|
