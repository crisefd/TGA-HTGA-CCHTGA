@feat_roulette_calculation_of_probabilites
Feature: Roulette's calculation of probabilites
  As a researcher,
  in order to perform roulette selection for the set of chromosomes,
  I want the calculation of probabilities for chromosomes to work correctly.

  @sce_roulette_selection_positive_fit
  Scenario: Set of chromosomes with only positive fitness values
    Given a set of chromosomes with positive fitness values
    When the array of probabilites is calculated, this should be sorted in ascending order, composed of float numbers between 0.0 and 1.0 with the last one being equal to 1.0
  
  @sce_roulette_selection_negative_fit
  Scenario: Set of chromosomes with negative fitness values
    Given a set of chromosomes with negative fitness values
    When the array of probabilites is calculated, this should be sorted in ascending order, composed of float numbers between 0.0 and 1.0 with the last one being equal to 1.0
