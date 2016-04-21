# language: en
# encoding: utf-8
# file: init_population.feature
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-04-21
# last modified:
# version: 0.2
# licence: GPL

Feature: Mutation operation
  @test_mutation
  Scenario: Test the mutation operation
    Given the chromosome:
    |1|1|-1|0|1|1|1|
    When mutation is apply on the mating pool
    Then the mutate chromosome changes on one gene 
