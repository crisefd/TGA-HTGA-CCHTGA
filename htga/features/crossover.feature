# language: en
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
    And the upper bounds are:
    |5|5|5|5|5|5|5|
    And the lower bounds are:
    |-5|-5|-5|-5|-5|-5|-5|
    When we apply crossover on the chromosomes
    Then the resulting chromosomes must have swapped their right sides
