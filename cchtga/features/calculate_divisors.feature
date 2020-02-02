# language: en
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-05-03

Feature: calculate divisors test

  @test_calculate_divisors
  Scenario: Test the divisors calculation
    Given a number of genes of 200:
    When the calculate divisors function is apply
    Then the resulting list of divisors should be
    |2|4|5|8|10|20|25|40|50|100|
