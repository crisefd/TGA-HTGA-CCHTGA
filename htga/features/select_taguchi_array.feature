@feat_select_taguchi_array
Feature: Select Taguchi Array
  As a researcher,
  in order to generate offspring by Taguchi method in HTGA,
  I want the selection of the most suitable Taguchi array subroutine to work correctly.

  @sce_5_vars
  Scenario: Problem with 5 variables
  Given that the size fo the chromosome is 5
  Then the selected Taguchi array should be L8
  
  @sce_15_vars
  Scenario: Problem with 15 variables
  Given that the size fo the chromosome is 15
  Then the selected Taguchi array should be L16
  
  @sce_55_vars
  Scenario: Problem with 55 variables
  Given that the size fo the chromosome is 55
  Then the selected Taguchi array should be L64