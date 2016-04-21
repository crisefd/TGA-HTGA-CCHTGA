# language: en
# encoding: utf-8
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-3-08

Feature: Tournament selection

  Scenario: Select two chromosomes to insert into the mating pool
    Given a population of any five chromosomes
    When tournament is apply on the population
    Then two different chromosomes must be randomly chosen
