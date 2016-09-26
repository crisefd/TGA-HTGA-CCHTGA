# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-09-25
Feature: correct chromosome test

  Scenario: Test the correction of chromosome with the first two genes as solution
    Given the chromosome:
      |1|1|1|1|1|1|1|
    And the weights:
      |2|3|8|8|8|8|8|
    And the max weight being 5
    When the correction is apply
    Then the resulting chromosome should be:
      |1|1|0|0|0|0|0|

  Scenario: Test the correction of chromosome with the first gene as solution
    Given the chromosome:
      |1|1|1|1|1|1|1|
    And the weights:
      |5|8|8|8|8|8|8|
    And the max weight being 5
    When the correction is apply
    Then the resulting chromosome should be:
      |1|0|0|0|0|0|0|

  Scenario: Test the correction of chromosome with the three gene as solution
    Given the chromosome:
      |1|1|1|1|1|1|1|
    And the weights:
      |2|2|8|8|8|8|1|
    And the max weight being 5
    When the correction is apply
    Then the resulting chromosome should be:
      |1|1|0|0|0|0|1|
  
  Scenario: Test the correction of chromosome with five genes as solution
    Given the chromosome:
      |1|1|1|1|1|1|1|
    And the weights:
      |1|1|1|1|8|1|8|
    And the max weight being 5
    When the correction is apply
    Then the resulting chromosome should be:
      |1|1|1|1|0|1|0|

  Scenario: Test the correction of an already good chromosome
    Given the chromosome:
      |1|1|1|1|1|1|1|
    And the weights:
      |1|1|1|1|1|1|1|
    And the max weight being 7
    When the correction is apply
    Then the resulting chromosome should be:
      |1|1|1|1|1|1|1|