@feat_convex_mutation
Feature: Convex mutation
  As a researcher,
  In order to mutate chromosomes in HTGA
  I want the convex mutation subroutine to work correctly.

  Scenario: Continuous variables
  Given a set of 10 chromosomes with continuous variables
  And a mutation rate of 10%
  When the mutation operation is apply over the chromosomes
  Then one chromosome should have been mutated
  And the changed genes in it must be closer stepwise