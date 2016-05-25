# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-05-25
Feature: mutation operation test

  @test_mutation_operation
  Scenario: Apply the mutation operation on chromosome
    Given the chromosome the size ten chromosome:
      |4|8|2|2|1|5|5|9|4|1|
    And the upper bounds:
      |10|10|10|10|10|10|10|10|10|10|
    And the lower bounds:
      |0|0|0|0|0|0|0|0|0|0| 
    And the best experience of current chromosome:
      |1|1|1|1|1|1|1|1|1|1|
    And the current best chromosome is:
      |0|1|0|1|0|0|0|0|0|0|
    And The probability of mutation is set to "0.5"
    When the mutation operation is apply
    Then half of the genes must be less than or equal than previous gene value minus one 
