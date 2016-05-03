# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-05-03

Feature: calculate divisors test

  @test_calculate_divisors

  Scenario: Test the divisors calculation
    Given the amount of gene:
    # |amount of gene|
      |5|

    When the calculate divisors is apply
    Then return a list with the divisors
