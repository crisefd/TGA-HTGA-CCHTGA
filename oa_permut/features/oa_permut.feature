@feat_generate_taguchi_array
Feature: Generation of Taguchi Array
  As a researcher,
  In order to generate orthogonal arrays
  I want the OA Permut algorithm to work correctly.

  @sce_generate_L8_array
  Scenario: There are 7 variables in the experiment
    Given the number of levels (Q) is 2
    And dimension (N) is 7
    And the parameter J is 3
    Then the output should be the L8 Taguchi array

  @sce_generate_L16_array
  Scenario: There are 15 variables in the experiment
    Given the number of levels (Q) is 2
    And dimension (N) is 15
    And the parameter J is 4
    Then the output should be the L16 Taguchi array

  @test_generate_L32_array
  Scenario: There are 31 variables in the experiment
    Given the number of levels (Q) is 2
    And dimension (N) is 31
    And the parameter J is 5
    Then the output should be the L31 Taguchi array
