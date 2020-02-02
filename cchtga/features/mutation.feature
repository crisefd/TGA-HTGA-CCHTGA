# language: en
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-05-25

Feature: mutation operation test # Needs to be fixed, is hard to test this one :(
  @test_mutation_operation
  Scenario: Apply the mutation operation on chromosome
    Given the size twenty chromosome:
      |2|1|1|1|1|1|1|1|2|1|1|1|1|1|1|1|1|1|2|1|
    And the upper bounds:
      |100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|
    And the lower bounds:
      |0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|
    And the best experience of current chromosome:
      |1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|
    And the current best chromosome is:
      |0|1|0|1|0|0|0|0|0|0|0|1|0|1|0|0|0|0|0|0|
    And the probability of mutation is set to "0.5"
    When the mutation operation is apply
    Then the resulting genes of chrmosomes must all be 40
    Then around half of the gene values of the mutated chromosome must be close to the previous gene value by maximum difference of one 
