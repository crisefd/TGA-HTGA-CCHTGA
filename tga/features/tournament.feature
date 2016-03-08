# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08

Feature: Tournament selection

  Scenario: Select two chromosomes to apply the reproduction operators
    Given a population of chromosomes
    When tournament is apply on the population select two chromosomes
    Then add the two differents chromosomes to the mating pool
