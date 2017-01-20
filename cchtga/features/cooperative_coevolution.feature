@feat_cooperative_coevolution
Feature: Cooperative coevolution
  As a researcher,
  in order to use the CCHTGA
  I want the cooperative coevolution subroutine to work correctly.

  Scenario: Updating best chromosomes
    Given a set of subsystems with subchromosomes that can improve the current best chromosome
    When the cooperative coevolution is applied, the best chromosome should have been updated

  Scenario: Updating best subchromosome experience
    Given a set of subsystems with a subchromosome that can improve a current best experience
    When the cooperative coevolution is applied, the best experience should have been updated