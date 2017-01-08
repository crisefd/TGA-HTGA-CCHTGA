@feat_generate_initial_population
Feature: Generate initial population
  As a researcher,
  In order to have an initial set of chromosomes
  I want the generation of initial population subroutine to work correctly.

  @sce_discrete_random_values
  Scenario: The random values are discrete
    Given a population size of 30
    And the number of genes is 10
    And the domain is [-11, 5]^10
    And the random values are discrete
    When The initial population is generated, each chromosome should be correct

  @sce_uniform_distribution_values
  Scenario: The random values are from a uniform distribution
    Given a population size of 30
    And the number of genes is 10
    And the domain is [-11, 5]^10
    And the random values are from a uniform distribution
    When The initial population is generated, each chromosome should be correct
