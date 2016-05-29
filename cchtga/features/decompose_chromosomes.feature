# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-05-29
Feature: Decompose the chromosomes into sub chromosomes  

  @test_decompose_operation
  Scenario: Decompose the chromosomes into subchromosomes
    Given the population of chromosomes:
      | 1 | 5 | -4 | 3 | 2 | 1 | 7 | 8 | 9 |
      | 1 | 1 | 4 | 0 | 2 | 3 | 7 | 5 | -4 |
      | 4 | 4 | 0 | -4 | 4 | 3 | 8 | 1 | 1 |
    And a subsystem with the variables:
      | 1 | 3 | 8 | 
    And the global lower bounds:
      | -5 | -5 | -5 | -5 | -5 | -5 | -5 | -5 | -5 |
    And the global upper bounds:
      | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
    When the decompose operation is apply
    Then the resulting subchromosomes should be:
      | 5 | 3 | 9 |
      | 1 | 0 | -4 |
      | 4 | -4 | 1 |
    And with upper and lower bounds:
    | 10 | 10 | 10 |
    | -5 | -5 | -5 |