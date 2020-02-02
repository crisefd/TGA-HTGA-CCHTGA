# language: en
# file: roulette_selection.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-29-11

Feature: select the better M chromosomes for the next generation
  @test_select_next_generation_max
  Scenario: Test the selection of the better M chromosomes to be parents of the next generation for a maximization problem
  Given a population size (M) of 6
  And the fitness values for the chromosomes are:
  |-4|-8|-1|9|3|-2|4|11|12|-10|
  When I sort the chromosomes by fitness in decreasing order and select the better M chromosomes
  Then the fitness values of the parents for then next generation are:
  |12|11|9|4|3|-1|

  @test_select_next_generation_min
  Scenario: Test the selection of the better M chromosomes to be parents of the next generation for a mimization problem
  Given a population size (M) of 6
  And the fitness values for the chromosomes are:
  |-4|-8|-1|9|3|-2|4|11|12|-10|
  When I sort the chromosomes by fitness in increasing order and select the better M chromosomes
  Then the fitness values of the parents for then next generation are:
  |-10|-8|-4|-2|-1|3|
