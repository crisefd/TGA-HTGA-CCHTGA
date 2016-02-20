# language: en
# encoding: utf-8
# file: roulette_selection.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-29-11
# last modified: 2015-29-11
# version: 0.2
# licence: GPL

Feature: select the better M chromosomes for the next generation
  @test_select_nex_generation
  Scenario: Test the selection of the better M chromosomes to be parents of the next generation
  Given a population size (M) of 6
  And the fitness values for the chromosomes are:
  |-4|-8|-1|9|3|-2|4|11|12|-10|
  When I sort the chromosomes by fitness in decreasing order and select the better M chromosomes
  Then the fitness values of the parents for then next generation are:
  |12|11|9|4|3|-1|
