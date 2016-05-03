# language: en
# encoding: utf-8
# file: init_population.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-10-07
# last modified: 2015-10-07
# version: 0.2
# licence: GPL

Feature: initial population test

  @test_discrete_value
  Scenario: Test generation of real values for genes with discrete values
    Given a population size of 5
    And a number of genes of 7
    And the upper bounds are
    |5|5|5|5|5|5|5|
    And the lower bounds are
    |-11|-11|-11|-11|-11|-11|-11|
    And the values for beta are "discrete"
    When I initialize  the HTGA and generate the initial population with continuous variables
    Then all of the chromosomes genes (values) for the initial population must be real numbers between their corresponding upper and lower bounds


    @test_uniform_distribution_value
    Scenario: Test generation of real values for genes with uniform distribution values
      Given a population size of 5
      And a number of genes of 7
      And the upper bounds are
      |5|5|5|5|5|5|5|
      And the lower bounds are
      |-11|-11|-11|-11|-11|-11|-11|
      And the values for beta are "uniform distribution"
      When I initialize  the HTGA and generate the initial population with continuous variables
      Then all of the chromosomes genes (values) for the initial population must be real numbers between their corresponding upper and lower bounds

      @test_non_continuous_variables
      Scenario: Test generation of integer values for genes
        Given a population size of 5
        And a number of genes of 7
        And the upper bounds are
        |5|5|5|5|5|5|5|
        And the lower bounds are
        |-11|-11|-11|-11|-11|-11|-11|
        And the values for beta are "discrete"
        When I initialize  the HTGA and generate the initial population with non continuous variables
        Then all of the chromosomes genes (values) for the initial population must be integer numbers between their corresponding upper and lower bounds
