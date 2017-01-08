@feat_convex_cross
Feature: Convex crossover
  As a researcher,
  In order to cross chromosomes in HTGA
  I want the convex crossover subroutine to work correctly.
  
  @sce_continuous_vars
  Scenario: Continuous variables
    Given population of 4 chromosomes with continuous variables
    And the domain is [-11, 7]^6
    And a set of 2 chromosomes selected for crossover using roulette selection
    When the crossover operation is applied
    Then the 4 newly added chromosomes should be the convex combination of their parents