@feat_has_best_fit_not_improved
Feature: Has best fit not improved
  As a researcher,
  in order to use the CCHTGA,
  I want the has best fit not improved validation to work correctly.

  @sce_nil_prev_chromo
  Scenario: Nil previous best chromosome
    Given a minimization problem with nil previous best chromosome
    Then the answer should be true

  @sce_greater_fit_best_cromo
  Scenario: Greater fitness for best chromosome
    Given a minization problem with best chromosome with a fitness greater than that of the previous best chromosome
    Then the answer should be true

  @sce_greater_fit_prev_best_chromo
  Scenario: Greater fitness for previous best chromosome
    Given a minimization problem with previous best chromosome with a fitness greater than that of the best chromosome
    Then the answer should be true