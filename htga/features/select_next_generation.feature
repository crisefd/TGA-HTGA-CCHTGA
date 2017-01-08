@feat_select_next_generation
Feature: Select next generation
  As a researcher,
  In order to select chromosomes for the next generation in HTGA
  I want the select next generation subroutine to work correctly.
  
  @sce_negative_fit_min_problem
  Scenario: Negative fitnesses and a minimization problem
  Given a population of D chromosomes with negative fitness values
  And optimization problem being a minimization one
  When the chromosomes are sort in increasing order to select the better M chromosomes (D > M)
  Then the number of chromosomes for the next generation should be M

  @sce_positive_fit_max_problem
  Scenario: Positive fitnesses and a maximization problem
  Given a population of D chromosomes with positive fitness values
  And optimization problem being a maximization one
  When the chromosomes are sort in increasing order to select the better M chromosomes (D > M)
  Then the number of chromosomes for the next generation should be M
  
