# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-11
# last modified: 2015-10-11
# version: 0.2
# licence: GPL

Feature: Mutation operation
  @test_mutation_non_continuous
  Scenario: Test the mutation operation derived from convex set theory with non continuous variables
    Given the chromosome:
    |1|1|-1|0|1|1|1|
    And a beta value of "0.5"
    When mutation is apply on genes 2 and 4
    Then the resulting chromosome must be:
    |1|1|0|0|0|1|1|
