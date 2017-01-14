@feat_taguchi_cross
Feature: Taguchi crossover
  As a researcher,
  in order to generate offspring by Taguchi method in HTGA,
  I want the taguchi crossover subroutine to work correctly.

  @sce_binary_vars
  Scenario: Binary variables
  Given set of chromosomes with binary values
  When 2 chromosomes are selected for crossover
  And the objective function is the sum of squares of x
  Then the optimal combination of these 2, should be added to the set.