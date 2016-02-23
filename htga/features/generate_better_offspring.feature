# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-2-22

Feature: Generation of better offspring by Taguchi method
  Scenario: Find the optimal chromosome by performing matrix experiments
    Given as a test function the sum of squares of x
    And the chromosome x being
    |1|1|1|1|0|0|0|
    And the chromosome y being
    |0|0|0|0|1|1|1|
    Then the optimal chromosome should be
    |0|0|0|0|0|0|0|