@feat_random_grouping
Feature: Random grouping

  @test_odd
  Scenario: Odd number of variables
    Given a chromosome with an odd number of genes
    When the random grouping is apply, each subsystems should've the same size and the sum should be equal to the total number of variables

  @test_even
  Scenario: Even number of variables
    Given a chromosome with an even number of genes
    When the random grouping is apply, each subsystems should've the same size and the sum should be equal to the total number of variables