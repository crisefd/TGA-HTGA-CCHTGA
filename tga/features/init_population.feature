# language: en
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08
Feature: initial population test

  @test_discrete_value
  Scenario: Test generation of real values for genes
    Given a population size of 5
    And a number of genes of 7
    And the upper bounds are
      | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
    And the lower bounds are
      | -11 | -11 | -11 | -11 | -11 | -11 | -11 |
    When I initialize  the TGA and generate the initial population with continuous variables
    Then all of the chromosomes genes (values) for the initial population must be real numbers between their corresponding upper and lower bounds

  @test_non_continuous_variables
  Scenario: Test generation of integer values for genes
    Given a population size of 5
    And a number of genes of 7
    And the upper bounds are
      | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
    And the lower bounds are
      | -11 | -11 | -11 | -11 | -11 | -11 | -11 |
    When I initialize  the TGA and generate the initial population with non continuous variables
    Then all of the chromosomes genes (values) for the initial population must be integer numbers between their corresponding upper and lower bounds
