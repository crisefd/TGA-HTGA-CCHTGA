# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-2-22

Feature: Generate the matrix experiments to be use to generate an optimal chromosome
  Scenario: Generate de matrix experiments for two given chromosomes
    Given the chromosome x being
    |1|1|1|1|0|0|0|
    And the chromosome y being
    |0|0|0|0|1|1|1|
    Then the resulting matrix experiments should be
    |1|1|1|1|0|0|0|
    |1|1|1|0|1|1|1|
    |1|0|0|1|0|1|1|
    |1|0|0|0|1|0|0|
    |0|1|0|1|1|0|1|
    |0|1|0|0|0|1|0|
    |0|0|1|1|1|1|0|
    |0|0|1|0|0|0|1|
