@feat_roulette_selection
Feature: Roulette selection
  As a researcher,
  In order to select chromosomes in the HTGA
  I want the roulette selection operation to work correctly.

  Scenario: Selection operation
    Given a population of 20 chromosomes
    And a 20% crossover rate
    Then 4 chromosomes are expected to be selected