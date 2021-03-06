# language: en
# file: matrix.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-02-19
# last modified: 2016-02-19
# version: 0.2
# licence: GPL

Feature: Generation of Taguchi Array
  @test_generate_L8_array
  Scenario: Test if a generated matrix is in fact, an L8 Taguchi array
    Given the number of levels Q is 2
    And N is 7
    And J is 3
    Then the resulting matrix should be:
    |0|0|0|0|0|0|0|
    |0|0|0|1|1|1|1|
    |0|1|1|0|0|1|1|
    |0|1|1|1|1|0|0|
    |1|0|1|0|1|0|1|
    |1|0|1|1|0|1|0|
    |1|1|0|0|1|1|0|
    |1|1|0|1|0|0|1|

  @test_generate_L16_array
  Scenario: Test if a generated matrix is in fact, an L16 Taguchi array
    Given the number of levels Q is 2
    And N is 15
    And J is 4
    Then the resulting matrix should be:
    |0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|
    |0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|
    |0|0|0|1|1|1|1|0|0|0|0|1|1|1|1|
    |0|0|0|1|1|1|1|1|1|1|1|0|0|0|0|
    |0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|
    |0|1|1|0|0|1|1|1|1|0|0|1|1|0|0|
    |0|1|1|1|1|0|0|0|0|1|1|1|1|0|0|
    |0|1|1|1|1|0|0|1|1|0|0|0|0|1|1|
    |1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|
    |1|0|1|0|1|0|1|1|0|1|0|1|0|1|0|
    |1|0|1|1|0|1|0|0|1|0|1|1|0|1|0|
    |1|0|1|1|0|1|0|1|0|1|0|0|1|0|1|
    |1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|
    |1|1|0|0|1|1|0|1|0|0|1|1|0|0|1|
    |1|1|0|1|0|0|1|0|1|1|0|1|0|0|1|
    |1|1|0|1|0|0|1|1|0|0|1|0|1|1|0|

  @test_generate_L32_array
  Scenario: Test if a generated matrix is in fact, an L16 Taguchi array
    Given the number of levels Q is 2
    And N is 31
    And J is 5
    Then the resulting matrix should be:
    |0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|
    |0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|
    |0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|0|0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|
    |0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|0|0|0|0|0|0|0|0|
    |0|0|0|1|1|1|1|0|0|0|0|1|1|1|1|0|0|0|0|1|1|1|1|0|0|0|0|1|1|1|1|
    |0|0|0|1|1|1|1|0|0|0|0|1|1|1|1|1|1|1|1|0|0|0|0|1|1|1|1|0|0|0|0|
    |0|0|0|1|1|1|1|1|1|1|1|0|0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|0|0|0|0|
    |0|0|0|1|1|1|1|1|1|1|1|0|0|0|0|1|1|1|1|0|0|0|0|0|0|0|0|1|1|1|1|
    |0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|
    |0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|
    |0|1|1|0|0|1|1|1|1|0|0|1|1|0|0|0|0|1|1|0|0|1|1|1|1|0|0|1|1|0|0|
    |0|1|1|0|0|1|1|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|0|0|1|1|0|0|1|1|
    |0|1|1|1|1|0|0|0|0|1|1|1|1|0|0|0|0|1|1|1|1|0|0|0|0|1|1|1|1|0|0|
    |0|1|1|1|1|0|0|0|0|1|1|1|1|0|0|1|1|0|0|0|0|1|1|1|1|0|0|0|0|1|1|
    |0|1|1|1|1|0|0|1|1|0|0|0|0|1|1|0|0|1|1|1|1|0|0|1|1|0|0|0|0|1|1|
    |0|1|1|1|1|0|0|1|1|0|0|0|0|1|1|1|1|0|0|0|0|1|1|0|0|1|1|1|1|0|0|
    |1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|
    |1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|
    |1|0|1|0|1|0|1|1|0|1|0|1|0|1|0|0|1|0|1|0|1|0|1|1|0|1|0|1|0|1|0|
    |1|0|1|0|1|0|1|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|0|1|0|1|0|1|0|1|
    |1|0|1|1|0|1|0|0|1|0|1|1|0|1|0|0|1|0|1|1|0|1|0|0|1|0|1|1|0|1|0|
    |1|0|1|1|0|1|0|0|1|0|1|1|0|1|0|1|0|1|0|0|1|0|1|1|0|1|0|0|1|0|1|
    |1|0|1|1|0|1|0|1|0|1|0|0|1|0|1|0|1|0|1|1|0|1|0|1|0|1|0|0|1|0|1|
    |1|0|1|1|0|1|0|1|0|1|0|0|1|0|1|1|0|1|0|0|1|0|1|0|1|0|1|1|0|1|0|
    |1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|
    |1|1|0|0|1|1|0|0|1|1|0|0|1|1|0|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|
    |1|1|0|0|1|1|0|1|0|0|1|1|0|0|1|0|1|1|0|0|1|1|0|1|0|0|1|1|0|0|1|
    |1|1|0|0|1|1|0|1|0|0|1|1|0|0|1|1|0|0|1|1|0|0|1|0|1|1|0|0|1|1|0|
    |1|1|0|1|0|0|1|0|1|1|0|1|0|0|1|0|1|1|0|1|0|0|1|0|1|1|0|1|0|0|1|
    |1|1|0|1|0|0|1|0|1|1|0|1|0|0|1|1|0|0|1|0|1|1|0|1|0|0|1|0|1|1|0|
    |1|1|0|1|0|0|1|1|0|0|1|0|1|1|0|0|1|1|0|1|0|0|1|1|0|0|1|0|1|1|0|
    |1|1|0|1|0|0|1|1|0|0|1|0|1|1|0|1|0|0|1|0|1|1|0|0|1|1|0|1|0|0|1|
