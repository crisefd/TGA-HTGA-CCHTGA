@feat_divide_vars
Feature: Divide variables
  As a researcher,
  in order to use the CC framework in the CCHTGA
  I want the divide variables subroutine to work correctly.

  @sce_odd
  Scenario: Odd number of variables
      Given a chromosomes with an odd number of genes
      When the variables are divided, the size of the original chromosome divided by the number of subsystem should yield a divisor of number of genes

  @sce_even
  Scenario: Even number of variables
      Given a chromosomes with an even number of genes
      When the variables are divided, the size of the original chromosome divided by the number of subsystem should yield a divisor of number of genes