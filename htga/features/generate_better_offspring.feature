# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-2-22

Feature: Generation of better offspring by Taguchi method
  @test_optimal_chromosome_size_seven
  Scenario: Find the optimal chromosome between two size seve chromosomes
    Given as a test function the sum of squares of z
    And the chromosome x being
    |1|1|1|1|0|0|0|
    And the chromosome y being
    |0|0|0|0|1|1|1|
    Then the optimal chromosome should be
    |0|0|0|0|0|0|0|

  @test_optimal_chromosome_size_five
  Scenario: Find the optimal chromosome between two size seve chromosomes
      Given as a test function the sum of squares of z minus sixteen times z
      And the chromosome x being
      |1|2|0|2|3|
      And the chromosome y being
      |-3|2|-1|4|2|
      Then the optimal chromosome should be
      |1|2|0|2|2|
