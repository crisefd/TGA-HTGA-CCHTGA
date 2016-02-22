# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-2-21

Feature: Selection of a suitable Taguchi array for matrix experiments
  @test_select_taguchi_array
  Scenario: Test the selection of suitable array to solve a problem
  Given that the population size is 32
  Then the selected Taguchi array should be L64
